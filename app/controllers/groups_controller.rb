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

			#trying multiple owners support: 
			if !Membership.find_by(group_id: @id).nil?
				@owners = @group.memberships.where(role: "owner")
				#returns a collection of Membership objects, NOT USERS. 
			end


		end
	end 
	def new
		@group = Group.new
		@groups = Group.limit(10)
		@users = User.all
		respond_to do |format|
		    format.html # new.html.erb
		    format.xml  { render :xml => @group }
    	end
	end

	def create

		@group = Group.new(group_params)
		@creator = params['creator']
		@group.users << User.find(@creator)
		puts "finding..."
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
	
	    @group = Group.find(params['id'])
	 #    params['groups'].each do |k|
		# 	@document.groups << Group.find_by_name(k)
		# end
		#params = what's being passed from the form 
		@checked = params['owners'] #new owner's user_id passed in. 
		
		#ensures owner is only added to the group once. 
		#alternate solution: specify custom primary key on join table
		begin
			@group.memberships.where(role: "owner").find(@checked)
			
		rescue ActiveRecord::RecordNotFound
			@group.users << User.find(@checked)
			
		else
		puts "ERROR"
		end


	    respond_to do |format|
	      if @group.update_attributes(group_params)
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
	    @users = User.all #for display in drop down menu..not ideal for now. 
	    @documents = @group.documents

	    if !Membership.find_by(group_id: @id).nil?
	    	puts "here"
			@owners = @group.memberships.where(role: "owner")
			#returns a collection of Membership objects, NOT USERS. 
			if !@owners.nil?
				puts "owner not nil"
				@first = User.find(@owners.first.user_id)
			else
				@first = @users.first.id
			end
		else
			puts "group not found in membership"
		end
 	end


	private 

	def group_params
    params.require(:group).permit(:name)
  end
end

	