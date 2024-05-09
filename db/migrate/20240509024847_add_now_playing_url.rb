class AddNowPlayingUrl < ActiveRecord::Migration[7.1]
  def change
    add_column :performances, :now_playing_url, :string
  end
end
