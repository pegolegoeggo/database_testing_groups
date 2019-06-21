class AddColumnsToDocuments < ActiveRecord::Migration
  def change
    add_column :documents, :title, :string
    add_column :documents, :body, :string
  end
end
