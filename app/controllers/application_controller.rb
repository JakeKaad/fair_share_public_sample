class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def require_admin
    redirect_to root_path unless admin_signed_in?
  end

  def require_login
    unless admin_signed_in? || user_signed_in?
      flash[:alert] = "Please sign in first."
      redirect_to root_path
    end
  end

  def require_owner
    redirect_to root_path unless owner?
  end

  def relevant_user
    id = params[:id] || params[:member_id]
    Member.find(id).user if current_user
  end

  def owner?
    current_user && relevant_user == current_user
  end

  def require_admin_or_owner
    redirect_to root_path unless owner? || admin_signed_in?
  end
end
