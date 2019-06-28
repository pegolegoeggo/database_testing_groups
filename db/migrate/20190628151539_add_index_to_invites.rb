class AddIndexToInvites < ActiveRecord::Migration
  def change
  	add_index :invites, [:sender_id, :group_id, :email], unique:true
  	change_column_null :invites, :sender_id, false
  end
end
