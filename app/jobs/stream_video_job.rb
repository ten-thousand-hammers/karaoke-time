class StreamVideoJob < ApplicationJob
  queue_as :default

  def perform(file_name)
    cmd = [
      "ffmpeg",
      "-i \"#{file_name}\"",
      "-map 0:a -map 0:v",
      "-f mp4",
      "-b:v 5M",
      "-acodec copy",
      "-listen 1",
      "-movflags frag_keyframe+default_base_moof",
      "-vcodec copy http://0.0.0.0:5556/1715134090"
    ].join(" ")

    `#{cmd}`
  end
end
