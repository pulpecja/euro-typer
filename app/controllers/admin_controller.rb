class AdminController < ApplicationController

  before_filter :require_admin!

  layout "application"

  def become
    return unless current_user.is_admin?
    sign_in(:user, User.find(params[:id]))
    redirect_to root_url # or user_root_url
  end

  private

  def require_admin!
    raise CanCan::AccessDenied unless current_user.is_admin?
  end

end
