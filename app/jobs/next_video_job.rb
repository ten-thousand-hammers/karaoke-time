class NextVideoJob < ApplicationJob
  queue_as :default

  def perform
    next_act = Act.order(created_at: :asc).first
    
    up_next_song = Performance.instance.up_next_song
    up_next_user = Performance.instance.up_next_user

    Performance.instance.update!(
      now_playing_song: nil,
      now_playing_user: nil,
    )

    sleep 10

    Performance.instance.update!(
      now_playing_song: up_next_song,
      now_playing_user: up_next_user,
      up_next_song: next_act&.song,
      up_next_user: next_act&.user
    )

    if up_next_song.present?
      up_next_song.increment!(:plays) 
      
      if up_next_user.present?
        user_song = up_next_user.user_songs.find_or_initialize_by(song: up_next_song) do |us|
          us.plays = 0
        end
        user_song.plays += 1
        user_song.save!
      end
    end

    next_act.destroy! if next_act.present?
  end
end
