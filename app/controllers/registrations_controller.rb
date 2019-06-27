#causes many errors right now :(
class RegistrationsController < Devise::RegistrationsController

	protected

	def new
 		super

	end

	def create 
		@resource = Person.new
		@token = params[:invite_token]
		if @token
			@newPerson = build_person(person_params)
	  		@newPerson.save
     		org =  Invite.find_by_token(@token).group #find the user group attached to the invite
     		@newPerson.groups << org #add this user to the new user group as a member

     		@gid = org.id
			@pid = @newPerson.id
			@membership = Devisemembership.find_by(group_id: @gid, person_id: @pid)
			@membership.role = 'member'
			@membership.save
			puts 'member added'
			redirect_to welcome_index_path
	    else 
	     	super
	    end
    end 

    def update
    	super
    end

    private 
    def person_params
    	params.require(:person).permit(:name, :email, :password, :password_confirmation)
    end
end

