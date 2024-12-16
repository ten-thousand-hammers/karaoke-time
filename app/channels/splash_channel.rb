class SplashChannel < ApplicationCable::Channel
  def subscribed
    puts "#{current_id} subscribed to splash channel"
    stream_from "splash"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def presence(data)
    # puts data
  end

  def ended(_data)
    # Clear the now_playing fields
    Performance.instance.update!(
      now_playing_song: nil,
      now_playing_user: nil
    )

    # Wait 10 seconds before starting the next song
    NextVideoJob.perform_later(wait: 10.seconds)
  end
end
