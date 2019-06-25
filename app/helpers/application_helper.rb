module ApplicationHelper
	def is_owner()
		#devise version 
		if !Devisemembership.find_by(group_id: @id).nil? && person_signed_in?
			@owners = @group.devisememberships.where(role: "owner")
			#returns a collection of Membership objects, NOT USERS.
			@memberships = @group.devisememberships.order('role DESC')

			#check if logged in user is an owner 
			@relation = Devisemembership.where(group_id: @id, person_id: current_person.id).first
			if !@relation.nil? && @relation.role == 'owner'
				puts 'is owner'
				true
			else
				false
				
			end

		else 
			false
		end

	end

	def in_group()
		!Devisemembership.find_by(group_id: @id, person_id: current_person.id).nil? && person_signed_in?
	end
end
