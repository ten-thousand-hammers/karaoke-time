class Auth0Controller < ApplicationController
  def callback
    # OmniAuth stores the information returned from Auth0 and the IdP in request.env['omniauth.auth'].
    # In this sample, you will pull the raw_info supplied from the id_token.
    # If the id_token is needed, you can get it from session[:userinfo]['credentials']['id_token'].
    # Refer to https://github.com/auth0/omniauth-auth0#authentication-hash for complete information on 'omniauth.auth' contents.
    session[:userinfo] = request.env['omniauth.auth']['extra']['raw_info']
    user = User.find_or_initialize_by(email: session[:userinfo]["email"])

    if user.new_record?
      user.name = session[:userinfo]["name"]
      user.picture = session[:userinfo]["picture"]
      user.nickname = user.name
      user.save!

      redirect_to edit_profile_url(user)
    else
      redirect_to search_url
    end
  end

  # if user authentication fails on the provider side OmniAuth will redirect to /auth/failure,
  # passing the error message in the 'message' request param.
  def failure
    @error_msg = request.params['message']
  end

  def logout
    reset_session
    redirect_to logout_url, allow_other_host: true
  end

  private

  AUTH0_CONFIG = Rails.application.config.auth0

  def logout_url
    request_params = {
      returnTo: root_url,
      client_id: Rails.application.config.auth0['auth0_client_id']
    }

    URI::HTTPS.build(host: AUTH0_CONFIG['auth0_domain'], path: '/v2/logout', query: request_params.to_query).to_s
  end
end
