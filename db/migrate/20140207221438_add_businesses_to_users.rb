class AddBusinessesToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :business_name, :string
  	add_column :users, :business_zipcode, :string
  	add_column :users, :business_address, :string
  	add_index :users, :business_address, :unique => true
  end
end
