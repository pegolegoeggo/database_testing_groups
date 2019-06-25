class WelcomeController < ApplicationController


  def index
  	if person_signed_in?
  		@mygroups = Person.find(current_person.id).groups.all
  	end
  end


end
