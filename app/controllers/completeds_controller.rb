class CompletedsController < ApplicationController
	
    def move
        q1 = Iou.where(debtor_id: params[:debtor], lender_id: current_user.id)
        q2 = Iou.where(debtor_id: current_user.id, lender_id: params[:debtor])
        q = q1 | q2
        q.each do |iou|
            Completed.create(description: iou.description, amt: iou.amt, lender_id: iou.lender_id, debtor_id: iou.debtor_id)
            iou.destroy
        end
        redirect_to '/'
    end

    def show_debts
        @q = Completed.where(debtor_id: current_user.id)
    end

    def show_loans
        @q = Completed.where(lender_id: current_user.id)
    end

end