class SplashChannel < ApplicationCable::Channel
  def subscribed
    puts "subscribed to splash channel"
    stream_from "splash"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
