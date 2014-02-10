class CreateConversations < ActiveRecord::Migration
  def change
    create_table :conversations do |t|
      t.string :content
      t.integer :user_id

      t.timestamps
    end
    add_index :conversations, [:user_id, :created_at]
  end
end
