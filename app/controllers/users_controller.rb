class UsersController < ApplicationController
	before_action :authenticate_user!

# home page / dashboard ------------------------------------------------

	def show
		@totalDebts = Iou.where(debtor_id: current_user.id).sum(:amt)
		@totalLoans = Iou.where(lender_id: current_user.id).sum(:amt)
	end


# debts page + loans page ----------------------------------------------

	# returns hash of user => amt you owe them
	def debts
		q = query()
		q.delete_if {|key, value| value <= 0}
		@simplifiedDebts = q
	end

	# returns hash of user => amt they owe you
	def loans
		q = query()
		q.delete_if {|key, value| value >= 0}
		@simplifiedLoans = q
	end

	# helper to extract ious where you are the debtor and where you are the lender
	# returns user => how much you owe (if + is a debt. if - is a loan)
	# if you owe a person and they owe you, get the diff btw those amounts
	# if you owe a person but they don't owe you, just how much you owe them
	# if you don't owe a person but they owe you, just (negative) how much they owe you
	def query

		# get the ious where the current user is the debtor (you owe money)
		dquery = Iou.select(:lender, sum(:amt)).where(debtor: current_user.debtor_id).group(:lender)
		# user_id of who you owe => amount you owe
		dusers = Hash.new
		dquery.each do |lender, amt_owed|
			dusers[User.select(:user_id).where(lender_id: lender)] = amt_owed
		end


		# get the ious where the current user is the lender (you are owed money)
		lquery = Iou.select(:debtor, sum(:amt)).where(lender: current_user.lender_id).group(:debtor)
		# user_id of who owes you => amount they owe
		lusers = Hash.new
		lquery.each do |debtor, amt_due|
			lusers[User.select(:user_id).where(debtor_id: debtor)] = amt_due
		end


		result = Hash.new
		dusers.each do |luser, amt_owed|

			# if you owe this person and this person owes you
			if (lusers.keys.include?(luser))
				amt_due = lusers[luser]
				diff = amt_owed - amt_due
				result[luser] = diff

			# if you owe this person and this person doesn't owe you
			else
				result[luser] = amt_owed
			end

		end
		lusers.each do |duser, amt_due|

			# if the person owes you but you don't owe them
			if (not dusers.keys.include?(duser))
				result[duser] =- amt_due
			end

		end
		return result
	end

# detailed debts page + detailed loans page ----------------------------

	# returns person you owe => list of ious between you and that person
	def detailed_debts
		# get the ious where the current user is the debtor (you owe money)
		lenders = Iou.select(:lender).where(debtor: current_user.debtor_id).distinct
		lusers = Array.new
		lenders.each do |l|
			lusers.push(User.select(:user_id, :lender_id, :debtor_id).where(lender_id: l))
		end

		# for each lender, get all ious between you and that lender
		result = Hash.new
		lusers.each do |luser|

			tmp = Array.new
			Iou.find_each do |t|
				if (t.lender == current_user.debtor_id  and t.debtor == current_user.debtor_id) or (t.lender == current_user.lender_id and t.debtor == lender)
					tmp.push(t)
				end
			end
			result[lender] = tmp

		end
		@detailedDebts = result
	end

	# returns person that owes you => list of ious between you and that person
	def detailed_loans
		# get the ious where the current user is the lender (they owe you money)
		debtors = Iou.select(:debtor).where(lender: current_user.debtor_id).distinct

		# for each debtor, get all ious between you and that debtor
		result = Hash.new
		debtors.each do |debtor|

			tmp = Array.new
			Iou.find_each do |t|
				if (t.lender = debtor and t.debtor = current_user.debtor_id) or (t.lender = current_user.lender_id and t.debtor = lender)
					tmp.push(t)
				end
			end
			result[lender] = tmp

		end
		@detailedLoans = result
	end
end
