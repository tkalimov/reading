class AddSecondsWatchedToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :seconds_watched, :integer
  end
end
