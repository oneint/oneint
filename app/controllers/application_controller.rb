class ApplicationController < ActionController::Base
  protect_from_forgery prepend: true
  before_action :set_workspace
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  layout :set_layout

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:company_name, :email])
  end

  def after_sign_in_path_for(user)
    workspace_path(user.workspaces.last)
  end

  def set_layout
    devise_controller? ? 'devise' : 'application'
  end

  def set_workspace
    @workspace = current_user && (current_user.workspaces.find_by(id: session[:current_workspace_id] || current_user.workspaces.first.id))
  end
end
