namespace :performance do
  task reset: :environment do
    Performance.instance.update!(
      up_next_song: nil,
      up_next_user: nil,
      now_playing_song: nil,
      now_playing_user: nil
    )
  end
end
