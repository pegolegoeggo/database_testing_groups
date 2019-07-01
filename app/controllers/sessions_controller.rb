class SessionsController < Devise::SessionsController
	def new
		super
	end

	def create
	#copied from devise github
	self.resource = warden.authenticate!(auth_options)
    set_flash_message!(:notice, :signed_in)
    sign_in(resource_name, resource)
    yield resource if block_given?

    #custom logic: pass in :invite_token if found
	if params[:invite_token]
		puts 'hi'
		@location= welcome_index_path(invite_token: params[:invite_token])
	else
		@location= after_sign_in_path_for(resource)
		
	end
	respond_with resource, location: @location
	end

	def destroy
		super
	end



end
