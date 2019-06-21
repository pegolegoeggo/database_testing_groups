class User < ActiveRecord::Base
	has_many :memberships
	has_many :groups, through: :memberships
	accepts_nested_attributes_for :memberships
end
