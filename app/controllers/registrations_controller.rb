#causes many errors right now :(
class RegistrationsController < Devise::RegistrationsController

	def new
 		super
	end

	def create 
		super
		# puts 'done super!'
		if params[:invite_token] && resource.save
			@token = params[:invite_token]
			@group = Invite.find_by(token: @token).group
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

