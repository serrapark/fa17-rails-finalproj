class ReminderMailer < ApplicationMailer
	default from: 'notifications@example.com'

	def reminder_email(user)
		@user = user
		mail(to: @user.email, subject: 'Reminder')
	end

end