class Invite < ActiveRecord::Base
	belongs_to :group
	belongs_to :sender, :class_name => 'Person'
	belongs_to :recipient, :class_name => 'Person'


	before_create :generate_token
	before_save :check_person_existence

	def generate_token
		self.token = Digest::SHA1.hexdigest([self.group_id, Time.now, rand].join)
	end
	def check_person_existence
		recipient = Person.find_by_email(email)
		if recipient
			self.recipient_id = recipient.id
		end
	end
end
