class SplashChannel < ApplicationCable::Channel
  def subscribed
    puts "#{current_id} subscribed to splash channel"
    stream_from "splash"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def presence(data)
    puts data
  end

  def ended(_data)
    Performance.instance.update!(
      now_playing_url: nil,
      now_playing_song: nil,
      now_playing_user: nil
    )
  end
end
