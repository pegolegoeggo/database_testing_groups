class InviteMailer < ApplicationMailer

	def invite_new_person(email, link, group)
		@link = link
		@group = group
		mail(to: email, subject: 'New Group Invitation')
	end

	def invite_existing_person(person, group)
		@person = person
		@group = group
		mail(to: @person.email, subject: 'You were added to a group')
	end

end
