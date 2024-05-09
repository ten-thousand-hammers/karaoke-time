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
      now_playing_song: Performance.instance.up_next_song,
      now_playing_user: Performance.instance.up_next_user,
      up_next_song: nil,
      up_next_user: nil
    )
  end
end
