class UsersController < ApplicationController
	before_action :authenticate_user!

# NOTES FOR FRONTEND ---------------------------------------------------
#
# For home page / dashboard
# 		@totalDebts is the sum of the current_user's debts (int)
# 		@totalLoans is the sum of the current_user's loans (int)
#
# For debts/loans page (see details link from homepage)
# 		@simplifiedDebts is how much the current_user owes each person if anything (person you owe => amount you owe them)
# 		@simplifiedLoans is how much the current_user lent each person if anything (person who owes you => amount they owe you)
#
# For detailed debts/loans page (idk if should be a separate page. whichever makes more sense / looks better. but these vars will be useful somehow)
# 		@detailedDebts is all the ious between the current user and the people they owe money to (person you owe => list of IOUs)
# 		@detailedLoans is all the ious between the current user and the people they lent money to (person who owes you => list of IOUs)

# home page / dashboard ------------------------------------------------

	def show
		@totalDebts = Iou.where(debtor_id: current_user.id).sum(:amt)
		@totalLoans = Iou.where(lender_id: current_user.id).sum(:amt)
		@user = current_user
		@simplifiedDebts = debts()
		@simplifiedLoans = loans()
		@detailedDebts = detailed_debts()
		@detailedLoans = detailed_loans()
	end

	def send_reminder_mail
		@user = User.find_for_authentication(:email => params[:debtor])
		ReminderMailer.reminder_email(@user).deliver
		redirect_to '/'
	end


# debts page + loans page ----------------------------------------------

	# returns hash of user => amt you owe them
	def debts
		q = query()
		q.delete_if {|key, value| value <= 0}
		return q
	end

	# returns hash of user => amt they owe you
	def loans
		q = query()
		q.delete_if {|key, value| value >= 0}
		q.each do |user, amt|
			q[user] = -amt
		end
		return q
	end

	# helper to extract ious where you are the debtor and where you are the lender
	# returns user => how much you owe (if + is a debt. if - is a loan)
	# if you owe a person and they owe you, get the diff btw those amounts
	# if you owe a person but they don't owe you, just how much you owe them
	# if you don't owe a person but they owe you, just (negative) how much they owe you
	def query

		# get the ious where the current user is the debtor (you owe money)
		dquery = Iou.where(debtor_id: current_user.id)
		# make hash from the person you owe => how much you owe them
		debts = Hash.new
		dquery.each do |iou|
			key = iou.lender_id
			if (debts.keys.include?(key))
				value = debts[key]
				debts[key] = value + iou.amt
			else
				debts[key] = iou.amt
			end
		end

		# get the ious where the current user is the lender (you are owed money)
		lquery = Iou.where(lender_id: current_user.id)
		# make hash from the person who owes you => how much they owe you
		loans = Hash.new
		lquery.each do |iou|
			key = iou.debtor_id
			if (loans.keys.include?(key))
				value = loans[key]
				loans[key] = value + iou.amt
			else
				loans[key] = iou.amt

			end
		end


		result = Hash.new
		debts.each do |lender, amt_owed|

			# if you owe this person and this person owes you
			if (loans.keys.include?(lender))
				amt_due = loans[lender]
				diff = amt_owed - amt_due
				result[User.find(lender).email] = diff

			# if you owe this person and this person doesn't owe you
			else
				result[User.find(lender).email] = amt_owed
			end

		end
		loans.each do |debtor, amt_due|

			# if the person owes you but you don't owe them
			if (not debts.keys.include?(debtor))
				result[User.find(debtor).email] = -amt_due
			end

		end
		return result
	end

# detailed debts page + detailed loans page ----------------------------

	# returns person you owe => list of ious between you and that person
	def detailed_debts
		# get the ious where the current user is the debtor (you owe money)
		dquery = Iou.where(debtor_id: current_user.id)
		# make set of people that have lent to you
		lenders = Set.new
		dquery.each do |iou|
			lenders.add(iou.lender_id)
		end

		# for each lender, get all ious between you and that lender
		result = Hash.new
		lenders.each do |lender|
			tmp = Array.new
			q1 = Iou.where("lender_id = ? and debtor_id = ?", lender, current_user.id)
			q2 = Iou.where("lender_id = ? and debtor_id = ?", current_user.id, lender)
			q = q1 | q2
			result[lender] = q
		end
		return result
	end

	# returns person that owes you => list of ious between you and that person
	def detailed_loans
		# get the ious where the current user is the lender (they owe you money)
		lquery = Iou.where(lender_id: current_user.id)
		# make set of people you have lent to
		debtors = Set.new
		lquery.each do |iou|
			debtors.add(iou.debtor_id)
		end

		# for each lender, get all ious between you and that lender
		result = Hash.new
		debtors.each do |debtor|
			tmp = Array.new
			q1 = Iou.where("lender_id = ? and debtor_id = ?", debtor, current_user.id)
			q2 = Iou.where("lender_id = ? and debtor_id = ?", current_user.id, debtor)
			q = q1 | q2
			result[debtor] = q
		end
		return result
	end
end






