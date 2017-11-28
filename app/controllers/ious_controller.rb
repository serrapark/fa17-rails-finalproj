class IousController < ApplicationController

	def new
		@iou = Iou.new
	end

	def create
		@iou = Iou.create(description: params[:description], amt: params[:amt], lender_id: params[:lender], debtor_id: params[:debtor])
        if @iou.valid?
            redirect_to '/'
        else
            redirect_to '/transaction/new'
            flash[:error] = @iou.errors.full_messages.to_sentence
        end
	end
	
end