class ProfileController < ApplicationController
  include Secured

  def edit
  end

  def update
    permitted_params = params.require(:user).permit(:nickname)
    if current_user.update(permitted_params)
      redirect_to root_url
    else
      render "edit"
    end
  end
end
