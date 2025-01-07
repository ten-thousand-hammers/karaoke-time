module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_id

    def connect
      # puts "connect #{cookies[:_karaoke_time_id]}"
      self.current_id = cookies[:_karaoke_time_id]
    end
  end
end
