class WelcomeController < ApplicationController


  def index
  	if person_signed_in?
  		@mygroups = Person.find(current_person.id).groups.order('role DESC')
      @token = params[:invite_token]
      puts @token

  		#note: this implementation is temporary but if we want to allow auto join, group name has to be unique
      begin
    		@groupName = params[:groupName]
    		if @groupName && Group.find_by(name: @groupName)
    			@group = Group.find_by(name: @groupName)
    			current_person.groups << @group

    			#set role to member
    			@devisemembership = @group.devisememberships.find_by(person_id: @current_person.id)
      		puts @devisemembership.role
      		@devisemembership.role = 'member'
      		@devisemembership.save
      		puts 'role set to member'
      		flash[:success] = 'Successfully Joined Group!'

      	elsif @groupName && Group.find_by(name: @groupName).nil?
          flash[:error] = 'Group not found!'
      	end
      rescue ActiveRecord::RecordNotUnique
        flash[:error] = 'Already in Group!'
      end



  	end
  end


end
