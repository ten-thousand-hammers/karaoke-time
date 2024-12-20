class BrowseController < ApplicationController
  include Secured

  def index
    @songs = Song.where(plays: 1..).order(:name).page(params[:page]).per(24)
  end
end
