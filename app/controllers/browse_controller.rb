class BrowseController < ApplicationController
  def index
    @songs = Song.order(:name).page(params[:page]).per(24)
  end
end
