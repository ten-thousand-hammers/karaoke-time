class SplashController < ApplicationController
  def index
    @performance = current_performance
  end
end
