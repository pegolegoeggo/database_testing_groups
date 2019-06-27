class Person < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :devisememberships
  has_many :groups, through: :devisememberships
  accepts_nested_attributes_for :devisememberships

  has_many :invitations, :class_name => "Invite", :foreign_key => 'recipient_id'
  has_many :sent_invites, :class_name => "Invite", :foreign_key => 'sender_id'

 #  after_create :invite_token

 #  def invite_token=(token)
 #  	if token
 #  		@group = Invite.find_by_token(token).group
 #  		self.groups << @group

	# 	#change role to member 
	# 	@devisemembership = @group.devisememberships.find_by(person_id: self.id)
	# 	@devisemembership.role = 'member'
	# 	@devisemembership.save
	# 	puts 'role set to member'
	# end
 #  end

end

