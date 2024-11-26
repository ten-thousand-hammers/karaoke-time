class QueueVideoJob < ApplicationJob
  queue_as :default

  def perform(song, user)
    # First create the act or update performance
    if Performance.instance.up_next_song.present?
      Act.create!(performance: Performance.instance, song: song, user: user)
    else
      Performance.instance.update!(
        up_next_song: song,
        up_next_user: user,
        up_next_download_status: song.downloaded ? 'completed' : 'downloading'
      )
    end

    # Then start the download if needed
    unless song.downloaded
      song.update!(download_status: :downloading)
      DownloadVideoJob.perform_now(song)
    end

    return if Performance.instance.now_playing_song.present?

    NextVideoJob.perform_later
  end
end
