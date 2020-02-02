class IntegrationsController < ApplicationController
  before_action :verify_user_owns_workspace, only: [:edit, :update]
  before_action :set_workspace
  def index
    @applications = Application.all
  end

  def new
    @application = Application.find(params[:application_id])
    @integration = Integration.new
  end

  def add
    @applications = Application.all
  end

  def update
    @application ||= Application.find(params[:integration][:application_id])
    if @integration.update_attributes(integration_params)
      flash[:notice] = "Integration was updated."
      redirect_to integrations_path
    else
      flash[:error] = @integration.errors.full_messages.join('<br/>').html_safe
      render :edit
    end
  end

  def create
    @integration = @workspace.integrations.new(integration_params)
    @application ||= Application.find(params[:integration][:application_id])

    if @integration.save
      flash[:notice] = "Integration with #{@application.name} was created!"
      redirect_to integrations_path
    else
      flash[:error] = @integration.errors.full_messages.join('<br/>').html_safe
      render :new
    end
  end

  private

  def integration_params
    params.require(:integration).permit(:api_key, 
      :application_id,
      :description,
      :additional_configuration_options => {})
  end

  def verify_user_owns_workspace
    @integration = Integration.find(params[:id])
    @application = @integration.application
    current_user.workspaces.find(@integration.workspace_id)
  end

  def set_workspace
    @workspace = current_user.workspaces.find_by(id: session[:current_workspace_id] || current_user.workspaces.first.id)
  end
end
