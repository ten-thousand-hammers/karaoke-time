class SkipUpNextJob < ApplicationJob
  queue_as :default

  def perform
    next_act = Act.order(created_at: :asc).first

    Performance.instance.update!(
      up_next_song: next_act&.song,
      up_next_user: next_act&.user
    )

    next_act.destroy! if next_act.present?
  end
end
