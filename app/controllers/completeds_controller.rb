class CompletedsController < ApplicationController
	def new
		@completed = Completed.new
	end

	def create
		@completed = Completed.create(description: params[:iou][:description], 
										amt: params[:iou][:amt]), 
										lender: params[:iou][:lender],
										debtor: params[:iou][:debtor])
	end
end