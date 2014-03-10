class AddBenchmarkingCategoriesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :business_neighborhood, :string
    add_column :users, :business_verticals, :string, array: true
    add_index  :users, :business_verticals, using: 'gin'
  end
end
