class InviteMailer < ApplicationMailer

	def invite_new_person(link, invite)
		@invite = invite
		@link = link
		mail(to: @invite.email, subject: 'You have an invitation to a group!')
	end

	def invite_existing_person(person, invite)
		@person = person
		@invite = invite
		mail(to: @person.email, subject: 'You were added to a group')
	end

end
