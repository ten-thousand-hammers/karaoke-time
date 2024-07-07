class SkipActJob < ApplicationJob
  queue_as :default

  def perform(act)
    act.destroy!
  end
end
