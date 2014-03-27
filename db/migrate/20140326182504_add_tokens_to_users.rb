class AddTokensToUsers < ActiveRecord::Migration
  def change
    add_column :users, :pocket_access_token, :string
    add_column :users, :google_access_token, :string
    add_column :users, :linkedin_access_token, :string
    add_column :users, :facebook_access_token, :string
    add_column :users, :khan_access_token, :string
    add_column :users, :khan_secret_token, :string
    add_column :users, :pocket_connected, :boolean, :default => false 
    add_column :users, :youtube_connected, :boolean, :default => false
    add_column :users, :khan_connected, :boolean, :default => false
    

  end
end
