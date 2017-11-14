class IousController < ApplicationController
	def new
		@iou = Iou.new
	end
end