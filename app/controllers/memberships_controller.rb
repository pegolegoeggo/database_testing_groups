class MembershipsController < ApplicationController
	def show 
	end 
	def destroy
		@id = params[:id]
		@membership = Membership.find(@id)
		@membership.destroy

		respond_to do |format|
			format.html {redirect_to :controller => 'groups', :action => 'index' }
			format.xml  { head :no_content }
		end
	end
end
