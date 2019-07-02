class InvitesController < ApplicationController
	def index
	end

	#actions for inviting existing users: email_invite and join_via_token
	def email_invite
		@gid = params[:group_id]
		@recipient = Person.find_by(email: params[:email])

		if @recipient #invite existin user, email notification
			@pid = @recipient.id
			begin
				@recipient.groups << Group.find(@gid)
				#set role to member since it's owner by default
				@membership = Devisemembership.find_by(group_id: @gid, person_id: @pid)
				@membership.role = 'member'
				@membership.save
				flash[:success] = @recipient.name.to_s + ' added'
				InviteMailer.invite_existing_person(@recipient, Group.find(@gid)).deliver
			
			rescue ActiveRecord::RecordNotUnique
				flash[:error] = 'already in group'		
			end

			redirect_to request.referrer

		else #email new user invite 
			@token = Invite.find_by(group_id: @gid).token
			if @token
				InviteMailer.invite_new_person(params[:email], 
					new_person_registration_path(invite_token: @token), Group.find(@gid)).deliver
				flash[:success] = 'New user invitation emailed'
			else
				flash[:error] = 'Please generate invite link first'
				
			end
			redirect_to request.referrer

		
		end
	end


	def join_via_token
		@token = params['token']
		puts 'token found'

		#make sure token is valid 
		begin
			org =  Invite.find_by(token: @token).group #find the user group attached to the invite
			current_person.groups << org #add this user to the new user group as a member
	 		@gid = org.id
			@pid = current_person.id
			@membership = Devisemembership.find_by(group_id: @gid, person_id: @pid)
			@membership.role = 'member'
			@membership.save
			flash[:success] = 'Successfully joined group!'

		rescue ActiveRecord::RecordNotUnique
			flash[:error] = 'already in group'

		rescue NoMethodError #if token is invalid, org will call .group on a nil class which returns this error
			flash[:error] = 'invalid token'
			
		end
		redirect_to welcome_index_path
		
	end

	def create
		@invite = Invite.new(invite_params) #make new invite
		@invite.sender_id = current_person.id #set sender to logged in PERSON
		# @invite.group_id = params[:group_id]

		if @invite.save

			redirect_to request.referrer
		end

	end


	private
	def invite_params
		params.require(:invite).permit(:email, :group_id, :sender_id, 
			:recipient_id, :token, :created_at, :updated_at)
	end
end
