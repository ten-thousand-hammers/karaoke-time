class NextVideoJob < ApplicationJob
  queue_as :default

  def perform
    next_act = Act.order(created_at: :desc).first
    Performance.instance.update!(
      now_playing_song: Performance.instance.up_next_song,
      now_playing_user: Performance.instance.up_next_user,
      up_next_song: next_act&.song,
      up_next_user: next_act&.user
    )
    next_act.destroy! if next_act.present?
  end
end
