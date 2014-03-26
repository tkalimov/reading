class AddSourceVideoIdToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :source_video_id, :string
  end
end
