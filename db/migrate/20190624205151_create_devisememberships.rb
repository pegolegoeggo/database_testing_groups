class CreateDevisememberships < ActiveRecord::Migration
  def change
    create_table :devisememberships do |t|
      t.integer :person_id, null: false
      t.integer :group_id, null: false
      t.string :role, default: "owner"
    end

  add_index :devisememberships, [:person_id, :group_id], unique:true
  end
end
