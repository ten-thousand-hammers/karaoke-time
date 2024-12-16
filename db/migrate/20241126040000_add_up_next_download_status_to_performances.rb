class AddUpNextDownloadStatusToPerformances < ActiveRecord::Migration[7.1]
  def change
    add_column :performances, :up_next_download_status, :string
  end
end
