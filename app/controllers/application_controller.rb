class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_current_user

  protected

  # Defines the current_user variable to store the current user's information if they are logged in.
  def set_current_user
    @current_user = User.find(session[:id]) if @current_user.nil? and session[:id]
  end

  # Logic executed at the beginning of a controller to ensure that the user is logged in.
  def login_required
    access_denied("Login required for this page.") and return false if ! @current_user
    return true
  end

  def admin_required
    access_denied("You are not authorized to access this page.") and return false if @current_user and ! @current_user.is_admin
    return true
  end

  def owner_required
    post = Post.find(params[:id])
    user_id = post.user_id
    access_denied("You are not authorized to access this page.") and return false if @current_user and  @current_user.id != user_id
    return true
  end

  def yours_required
    user = User.find(params[:id])
    user_id = user.id
    access_denied("You are not authorized to access this page.") and return false if @current_user and  @current_user.id != user_id
    return true
  end

  # Logic executed when a user accesses a page they are not allowed to visit.
  def access_denied(err=nil)
    # Set this return value so that the user will be returned to the requested page upon login.
    session[:return_to] = request.fullpath
    # Set the error message if one was defined.
    flash[:error] = err if err != nil
    # Redirect to the login page.
    redirect_to '/login'
  end
end
