class AddColumnsToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :name, :string
  end
end
