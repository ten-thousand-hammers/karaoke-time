class NextVideoJob < ApplicationJob
  queue_as :default

  def perform
    next_act = Act.order(created_at: :asc).first
    up_next_song = Performance.instance.up_next_song
    Performance.instance.update!(
      now_playing_song: Performance.instance.up_next_song,
      now_playing_user: Performance.instance.up_next_user,
      up_next_song: next_act&.song,
      up_next_user: next_act&.user
    )
    up_next_song.increment!(:plays) if up_next_song.present?
    next_act.destroy! if next_act.present?
  end
end
