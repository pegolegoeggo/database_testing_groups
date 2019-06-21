class AddIndexToMemberships < ActiveRecord::Migration
  def change
  	add_index :memberships, [:user_id, :group_id], unique:true
  	change_column_null :memberships, :group_id, false
  	change_column_null :memberships, :user_id, false
  end
end
