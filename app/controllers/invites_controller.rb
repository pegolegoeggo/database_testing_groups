class InvitesController < ApplicationController
	def index
	end
	def create
		@invite = Invite.new(invite_params) #make new invite
		@invite.sender_id = current_person.id #set sender to logged in PERSON

		if @invite.save
			#send the invite data to our mailer to deliver the email)
			#won't work until third party email is set up 
			#InviteMailer.invite_new_person(@invite, new_person_registration_path(:invite_token => @invite.token)).deliver 

			if !@invite.recipient.nil?
				#send notification email, automatically add to group: might wanna change. 
				InviteMailer.invite_existing_person(@invite.recipient, @invite).deliver

				#automatically add person to group. Or rather, add group to person
				@invite.recipient.groups << @invite.group

				#set role to member since it's owner by default
				@gid = @invite.group.id
				@pid = @invite.recipient.id
				@membership = Devisemembership.find_by(group_id: @gid, person_id: @pid)
				@membership.role = 'member'
				@membership.save
				puts 'member added'
				redirect_to request.referrer
			end

		else
			#oh no! creating a new invitation failed. 
			redirect_to request.referrer
		end
	end

	private
	def invite_params
		params.require(:invite).permit(:email, :group_id, :sender_id, 
			:recipient_id, :token, :created_at, :updated_at)
	end
end
