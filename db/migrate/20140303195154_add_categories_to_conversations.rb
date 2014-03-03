class AddCategoriesToConversations < ActiveRecord::Migration
  def change
  	add_column :conversations, :category, :string
  end
end
