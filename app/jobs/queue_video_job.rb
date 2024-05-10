class QueueVideoJob < ApplicationJob
  queue_as :default

  def perform(song, user)
    ext = "mp4"

    destination_path = File.join("public", "videos", "#{song.external_id}.#{ext}")
    unless File.exist?(destination_path)
      DownloadVideoJob.perform_now("https://www.youtube.com/watch?v=#{song.external_id}")
      song.update!(path: File.join("videos", "#{song.external_id}.#{ext}"))
    end

    if Performance.instance.up_next_song.present?
      Act.create!(song: song, user: user)
    else
      Performance.instance.update!(
        up_next_song: song,
        up_next_user: user
      )
    end
    
    return if Performance.instance.now_playing_song.present?
    
    sleep 5
    Performance.instance.update!(
      up_next_song: nil,
      up_next_user: nil,
      now_playing_song: song,
      now_playing_user: user,
    )
  end
end
