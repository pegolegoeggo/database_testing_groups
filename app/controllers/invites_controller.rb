class InvitesController < ApplicationController
	def index
	end

	def create
		@invite = Invite.new(invite_params) #make new invite
		@invite.sender_id = current_person.id #set sender to logged in PERSON
		@token = @invite.token
		if (@token && Invite.find_by(token: @token) && @invite.group_id.nil?) 
			@invite.group_id = Invite.find_by(token: @token).group.id #need this before @invite.save
		end

		begin 

			if @invite.save
				#send the invite data to our mailer to deliver the email)
				#won't work until third party email is set up 
				#InviteMailer.invite_new_person(@invite, new_person_registration_path(:invite_token => @invite.token)).deliver 

				if @token && @invite.email.nil? #invite via token on user home page
					puts 'token found'

					#make sure token is valid 
					org =  Invite.find_by(token: @token).group #find the user group attached to the invite
					@invite.group_id = Invite.find_by(token: @token).group.id
	     			current_person.groups << org #add this user to the new user group as a member
		     		@gid = org.id
					@pid = current_person.id
					@membership = Devisemembership.find_by(group_id: @gid, person_id: @pid)
					@membership.role = 'member'
					@membership.save
					flash[:success] = 'Successfully joined group!'

					redirect_to welcome_index_path


				elsif @invite.recipient #invite existing user
					puts 'invite existing'
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



				else #invite new user by email entry, currently disabled. not sure how to proceed...
					puts 'else'
					#send invite token that anyone can use to join group, not just new users
					#InviteMailer.invite_new_person(new_person_registration_path(:invite_token => @invite.token), @invite).deliver


					#InviteMailer.invite_new_person(welcome_index_path(:invite_token => @invite.token), @invite).deliver

					flash[:error] = "User not found"
					redirect_to controller: 'groups', action: 'edit', id: @invite.group_id, invite_token: @invite.token
				end


			else
				#oh no! creating a new invitation failed. 
				redirect_to request.referrer
			end
		rescue ActiveRecord::RecordNotUnique
			flash[:error] = 'already joined group'
			redirect_to welcome_index_path

		rescue ActiveRecord::StatementInvalid
			flash[:error] = 'invalid token'
			redirect_to welcome_index_path

		end
	end

	private
	def invite_params
		params.require(:invite).permit(:email, :group_id, :sender_id, 
			:recipient_id, :token, :created_at, :updated_at)
	end
end
