class Business < ActiveRecord::Base
	has_many :users, dependent: :destroy
	validates :name, presence: true, length: { maximum: 50 }
end
