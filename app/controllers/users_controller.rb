class UsersController < ApplicationController

	def show
		if (params.has_key?(:id))
			@id = params['id']
			@name = User.find(@id).name
			@email = User.find(@id).email
			@groups = User.find(@id).groups
			

		end
	end 
	def new
		@user = User.new
		@users = User.all
		respond_to do |format|
		    format.html # new.html.erb
		    format.xml  { render :xml => @user }
    	end
	end

	def create

		@user = User.new(user_params)
		if @user.save
			# # @document.groups << @groups
			redirect_to new_user_path
		else
			render :new
		end
	end

	private 

	def user_params
    params.require(:user).permit(:name, :email)
  end
end
