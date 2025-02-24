class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  helper_method :current_user
  before_action :require_logged_in!

  rescue_from CanCan::AccessDenied do |exception|
    flash[:errors] = [ exception.message ]
    redirect_to root_url
  end

  private

  def current_user
    User.find_by(session_token: session[:session_token])
  end

  def log_in(user)
    @current_user = user
    session[:session_token] = user.reset_token!
  end

  def log_out
    current_user.reset_token!
    session[:session_token] = nil
  end

  def require_logged_in!
    redirect_to new_session_url unless current_user
  end
end
