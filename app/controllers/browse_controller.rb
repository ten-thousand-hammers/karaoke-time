class BrowseController < ApplicationController
  include Secured
  
  def index
    @results = Song.order(:name).page(params[:page]).per(24)
  end
end
