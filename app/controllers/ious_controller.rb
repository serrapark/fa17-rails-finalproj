class IousController < ApplicationController

	def new
		@iou = Iou.new
	end

	def create
		@iou = Iou.create(description: params[:iou][:description], amt: params[:iou][:amt])
	end
	
end