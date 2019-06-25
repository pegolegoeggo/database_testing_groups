class GroupsController < ApplicationController
	
	def index
		if params['search']
			@groups = Group.where(["name LIKE ?", "%#{params['search']}%"])
		else
			@groups = Group.all
		end
	end
	def show
		if (params.has_key?(:id))
			@id = params['id']
			@group = Group.find(@id)
			@name = @group.name
			@documents = Group.find(@id).documents

			#need to account for multiple owners: not yet available.
			# if !Membership.find_by(group_id: @id).nil?
			# 	@owner_id = Membership.find_by(group_id: @id).user_id
			# 	@owner = User.find(@owner_id).name
			# 	puts @owner		
			# end

			#trying multiple owners support WORKING: 
			# if !Membership.find_by(group_id: @id).nil?
			# 	@owners = @group.memberships.where(role: "owner")
			# 	#returns a collection of Membership objects, NOT USERS.
			# 	@memberships = @group.memberships.order('role DESC')
			# end

			# @is_owner = false
			# #devise version 
			if !Devisemembership.find_by(group_id: @id).nil? && person_signed_in?
				@owners = @group.devisememberships.where(role: "owner")
				#returns a collection of Membership objects, NOT USERS.
				@memberships = @group.devisememberships.order('role DESC')
			end

			# 	#check if logged in user is an owner 
			# 	@relation = Devisemembership.where(group_id: @id, person_id: current_person.id).first
			# 	if !@relation.nil? && @relation.role == 'owner'
			# 		@is_owner = true
			# 		puts 'is owner'

			# 	end


				
			# end


		end
	end 
	def new
		@group = Group.new
		@groups = Group.limit(10)
		respond_to do |format|
		    format.html # new.html.erb
		    format.xml  { render :xml => @group }
    	end
	end

	def create

		@group = Group.new(group_params)
		# @creator = params['creator']
		# @group.users << User.find(@creator)
		if person_signed_in?
			@group.people << current_person
		end
		#role set to owner as default  
		#when adding using to a group, just make sure to find membership using both user and group id, 
		#then change the role using update_attribute. 
		if @group.save
			# # @document.groups << @groups
			redirect_to new_group_path
		else
			render :new
		end
	end

def update
	
	@group_id = params['id']
	@group = Group.find(@group_id)
	@checked = params['owners'] #new owner's user_id passed in. 
	@new_member_id = params['members']

	if !@group.devisememberships.nil?
		for rel in @group.devisememberships
			@pid = rel.person_id.to_s
			@current_role = rel.role
			@selected_role = params['role' + @pid]
			if @current_role != @selected_role
				rel.role = @selected_role
				rel.save
				puts "role updated"
			end

		end
	end

	respond_to do |format|
	    if @group.update_attributes(group_params)
	    	@new = false
	    	begin 
	    		@group.people.find(@new_member_id)
	    	rescue ActiveRecord::RecordNotFound
	    		@new = true
	    	end 

	    	if !@new_member_id.blank? && @new
	    		puts "new member!"
	    		# @group.users << User.find(@new_member_id)
	    		@group.people << Person.find(@new_member_id)

	    		#change role to member 
	    		@devisemembership = @group.devisememberships.find_by(person_id: @new_member_id)
	    		puts @devisemembership.role
	    		@devisemembership.role = 'member'
	    		@devisemembership.save
	    		puts 'role set to member'
	    		# @group.memberships.find_by(user_id: @new_member_id).save
	    	end


	      	if !@checked.blank?
	      		begin
	      			# @group.users << User.find(@checked)
	      			@group.people << Person.find(@checked)
	      		rescue ActiveRecord::RecordNotUnique
	      			puts 'no change'
	      		end 
			    
			end
	    
		format.html { redirect_to(@group, :notice => 'Group was successfully updated.') }
		format.xml  { head :ok }
	else
	    render :edit
	end
	end
end

	def edit
		#db calls
		@id = params['id']
	    @group = Group.find(@id)
		# @users = User.all #for display in drop down menu..not ideal for now. 
		@users = Person.all #changed from User.all
		@documents = @group.documents

	    if !Devisemembership.find_by(group_id: @id).nil?
	    	puts "here"
			@owners = @group.devisememberships.where(role: "owner")
			#returns a collection of Membership objects, NOT USERS. 
			# if !@owners.nil? && @owners.length > 0 #first clause not enough to handle no owners case
			# 	puts "owner not nil"
			# 	@first = User.find(@owners.first.user_id).id
			# else
			# 	@first = @users.first.id
			# end

			@memberships = @group.devisememberships

		else
			puts "group not found in membership"
		end

		#only show page if owner. prevents people from hacking via url
		# @is_owner = false
		# 	#devise version 
		# 	if !Devisemembership.find_by(group_id: @id).nil? && person_signed_in?
		# 		@owners = @group.devisememberships.where(role: "owner")
		# 		#returns a collection of Membership objects, NOT USERS.
		# 		@memberships = @group.devisememberships.order('role DESC')

		# 		#check if logged in user is an owner 
		# 		@relation = Devisemembership.where(group_id: @id, person_id: current_person.id).first
		# 		if !@relation.nil? && @relation.role == 'owner'
		# 			@is_owner = true
		# 			puts 'is owner'

		# 		end


				
		# 	end
 	end

 	#remove someone from the group 
 	def remove_member
		@m_id = params[:m_id] #id of the membership in the membership join table 
		@membership = Devisemembership.find(@m_id)
		@membership.destroy

		respond_to do |format|
			format.html {redirect_to request.referrer}
			format.xml  { head :no_content }
		end
	end


	private 

	def group_params
    	params.require(:group).permit(:name)
	end
end

	
