class QueueVideoJob < ApplicationJob
  queue_as :default

  def perform(external_id, singer)
    ext = "mp4"

    song = Song.find_by(external_id: external_id) 
       
    destination_path = File.join("public", "videos", "#{song.name}---#{song.external_id}.#{ext}")
    unless File.exist?(destination_path)
      DownloadVideoJob.perform_now("https://www.youtube.com/watch?v=#{song.external_id}")
      song.update!(path: File.join("videos", "#{song.name}---#{song.external_id}.#{ext}"))
    end

    if Performance.instance.up_next_song.present?
      Act.create!(song: song, user: singer)
    else
      Performance.instance.update!(
        up_next_song: song,
        up_next_user: singer
      )
    end
    
    return if Performance.instance.now_playing_song.present?
    
    sleep 5
    Performance.instance.update!(
      up_next_song: nil,
      up_next_user: nil,
      now_playing_song: song,
      now_playing_user: singer,
    )
  end
end
