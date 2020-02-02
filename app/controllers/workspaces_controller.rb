class WorkspacesController < ApplicationController
  before_action :set_workspace, only: [:show, :update, :edit]
  def new
    @workspace = Workspace.new
  end

  def create
    workspace = current_user.workspaces.new(workspace_params)
    if workspace.save
      redirect_to workspace_path(workspace)
    else
      render :new
    end
  end

  def show
    @applications = Application.all
    @requests = @workspace.requests.order(requested_at: :desc)
  end

  def edit
  end

  def update
    if @workspace.update_attributes(workspace_params)
      redirect_to workspace_path(@workspace)
    else
      render :edit
    end
  end

  private

  def workspace_params
    params.require(:workspace).permit(:name)
  end

  def set_workspace
    @workspace = params[:id].present? ? current_user.workspaces.find(params[:id]) : current_user.current_or_default_workspace
    session[:current_workspace_id] = @workspace.id
  end
end
