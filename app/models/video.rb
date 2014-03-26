class Video < ActiveRecord::Base
	belongs_to :user
	validates :title, uniqueness: { scope: :user_id, message: "of this video already recorded for user"}
end
