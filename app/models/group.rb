class Group < ActiveRecord::Base
	has_and_belongs_to_many :documents
	#has_many :documents
	has_many :memberships
	has_many :users, through: :memberships
	accepts_nested_attributes_for :memberships
end

