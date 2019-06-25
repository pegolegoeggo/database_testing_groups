class InviteMailer < ApplicationMailer

	def invite_new_person(invite, link)
		@invite = invite
		@link = link
		mail(to: @person.email, subject: 'You have an invitation to a group!')
	end

	def invite_existing_person(person, invite)
		@person = person
		@invite = invite
		mail(to: @person.email, subject: 'You were added to a group')
	end

end
