class CompletedsController < ApplicationController
	def new
		@completed = Completed.new
	end
end