class UsersController < ApplicationController
	before_action :authenticate_user!

	def show
		@username = current_user.email
		@debts_amt = sum_debts()
		@loans_amt = sum_loans()
	end

	def sum_debts
		sum = 0
		Iou.find_each do |t|
			if (t.debtor_id == current_user.debtor_id)
				sum += t.amt
			end
		end
		return sum
	end

	def sum_loans
		sum = 0
		Iou.find_each do |t|
			if (t.lender_id == current_user.lender_id)
				sum += t.amt
			end
		end
		return sum
	end
end