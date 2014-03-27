class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.integer :user_id
      t.string :title
      t.text :url
      t.integer :word_count
      t.datetime :time_added
      t.datetime :time_read
      t.string :categories, array: true
      t.timestamps
    end
  end
end
