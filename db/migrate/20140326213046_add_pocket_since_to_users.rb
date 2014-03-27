class AddPocketSinceToUsers < ActiveRecord::Migration
  def change
    add_column :users, :pocket_since, :timestamp
  end
end
