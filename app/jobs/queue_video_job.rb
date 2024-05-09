class QueueVideoJob < ApplicationJob
  queue_as :default

  def perform(external_id, singer)
    ext = "mp4"

    song = Song.find_by(external_id: external_id) 


    # ActionCable.server.broadcast(
    #   "splash", 
    #   {
    #     "event": "queue", 
    #     "title": title,
    #     "singer": singer
    #   }
    # )
    
    
    video_url = "https://www.youtube.com/watch?v=#{song.external_id}"
    destination_path = File.join("public", "videos", "#{song.name}---#{song.external_id}.#{ext}")
    unless File.exist?(destination_path)
      DownloadVideoJob.perform_now(video_url)
      song.update!(path: File.join("videos", "#{song.name}---#{song.external_id}.#{ext}"))
    end

    Performance.instance.update!(
      up_next_song: song,
      up_next_user: singer
    )
    sleep 5

    unless Performance.instance.now_playing_song.present?
      Performance.instance.update!(
        up_next_song: nil,
        up_next_user: nil,
        now_playing_song: song,
        now_playing_user: singer,
      )
    end

    # ActionCable.server.broadcast(
    #   "splash", 
    #   {
    #     "event": "play", 
    #     "url": File.join("videos", "#{title}---#{id}.#{ext}"),
    #     "title": title,
    #     "singer": singer
    #   }
    # )
  end
end
