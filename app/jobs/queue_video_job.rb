class QueueVideoJob < ApplicationJob
  queue_as :default

  def perform(id, title, singer)
    ext = "mp4"

    Performance.instance.update!(
      up_next_song: title,
      up_next_user: singer
    )

    # ActionCable.server.broadcast(
    #   "splash", 
    #   {
    #     "event": "queue", 
    #     "title": title,
    #     "singer": singer
    #   }
    # )
    sleep 5
    
    video_url = "https://www.youtube.com/watch?v=#{id}"
    destination_path = File.join("public", "videos", "#{title}---#{id}.#{ext}")
    DownloadVideoJob.perform_now(video_url) unless File.exist?(destination_path)

    Performance.instance.update!(
      up_next_song: nil,
      up_next_user: nil,
      now_playing_url: File.join("videos", "#{title}---#{id}.#{ext}"),
      now_playing_song: title,
      now_playing_user: singer,
    )

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
