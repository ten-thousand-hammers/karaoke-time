namespace :reset do
  task all: :environment do
    Performance.instance.update!(
      up_next_song: nil,
      up_next_user: nil,
      now_playing_song: nil,
      now_playing_user: nil
    )
    Act.destroy_all
    UserSong.destroy_all
    Song.destroy_all
    FileUtils.rm_rf(Rails.root.join("public", "videos"))
  end
end