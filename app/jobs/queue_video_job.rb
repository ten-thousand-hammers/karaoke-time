class QueueVideoJob < ApplicationJob
  queue_as :default

  def perform(id, title, singer)
    ext = "mp4"

    ActionCable.server.broadcast(
      "splash", 
      {
        "event": "queue", 
        "title": title,
        "singer": singer
      }
    )
    sleep 5
    
    video_url = "https://www.youtube.com/watch?v=#{id}"
    destination_path = File.join("public", "videos", "#{title}---#{id}.#{ext}")
    DownloadVideoJob.perform_now(video_url) unless File.exist?(destination_path)
    ActionCable.server.broadcast(
      "splash", 
      {
        "event": "play", 
        "url": File.join("videos", "#{title}---#{id}.#{ext}"),
        "title": title,
        "singer": singer
      }
    )
  end
end
