class BrowseController < ApplicationController
  include Secured

  def index
    @songs = Song.where(plays: 1..).order(:name)

    if params[:page].present?
      @songs = @songs.page(params[:page]).per(24)
    else
      @songs = @songs.page(1).per(24)
    end
  end
end
