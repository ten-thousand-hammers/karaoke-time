class QueueVideoJob < ApplicationJob
  queue_as :default

  def perform(song, user)
    DownloadVideoJob.perform_now(song) unless song.downloaded

    if Performance.instance.up_next_song.present?
      Act.create!(performance: Performance.instance, song: song, user: user)
    else
      Performance.instance.update!(
        up_next_song: song,
        up_next_user: user
      )
    end

    return if Performance.instance.now_playing_song.present?

    NextVideoJob.perform_later
  end
end
