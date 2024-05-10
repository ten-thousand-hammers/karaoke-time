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
    NextVideoJob.perform_later
  end
end
