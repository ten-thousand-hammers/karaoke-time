class BrowseController < ApplicationController
  include Secured

  def index
    @songs = Song.where(plays: 1..).order(:name)

    @songs = if params[:page].present?
      @songs.page(params[:page]).per(24)
    else
      @songs.page(1).per(24)
    end
  end
end
