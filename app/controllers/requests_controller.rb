class RequestsController < ApplicationController
  def new
    @request = @workspace.requests.new
  end

  def create
    @request = @workspace.requests.new(request_params)
    if @request.save
      redirect_to workspace_path(@workspace), notice: 'Request was submitted'
    else
      render :new
    end
  end

  def show
    @request = @workspace.requests.find(params[:id])
  end
private

  def request_params
    params.require(:request).permit(:external_user_identifier, :request_type, :appsflyer_advertising_id, :requested_at)
  end
end
