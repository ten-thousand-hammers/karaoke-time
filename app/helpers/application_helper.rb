module ApplicationHelper
  def current_performance
    Performance.instance
  end
end
