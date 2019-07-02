class RegistrationsController < Devise::RegistrationsController

	def new
 		super
	end

# added error handling but flashes are formatted weirdly
	def create 
		super
		# puts 'done super!'
		if params[:invite_token] && resource.save
			@token = params[:invite_token]
			begin
				@group = Invite.find_by(token: @token).group

			rescue NoMethodError
				flash[:error] = 'invalid token. unable to join group'
				return #early return
			end
			resource.groups << @group

			#set role to member
			@membership = Devisemembership.find_by(group_id: @group.id, person_id: resource.id)
			@membership.role = 'member'
			@membership.save
		end


    end 

    def update
    	super
    end

end

