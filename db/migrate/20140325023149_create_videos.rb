class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :title
      t.datetime :watched
      t.string :category
      t.integer :length
      t.string :publisher

      t.timestamps
    end
  end
end
