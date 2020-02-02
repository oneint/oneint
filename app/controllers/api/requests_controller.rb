class Api::RequestsController < Api::BaseController
  def index
    render json: @workspace.requests.last(150).to_json
  end

  def create
    new_req = @workspace.requests.new(request_type: request_params[:request_type], external_user_identifier: request_params[:user_id])
    if request_params[:appsflyer_attributes].present? && @workspace.applications.map{|app| app.name.downcase}.include?('appsflyer')
      new_req.appsflyer_advertising_id = request_params[:appsflyer_attributes][:advertising_id]
    end
    if new_req.save
      render json: {request: {id: new_req.id}}, status: 200
    elsif
      render json: {errors: new_req.errors.full_messages}.to_json, status: 400
    end
  end

  def show
    req = @workspace.requests.find(params[:id])
    render json: req.to_json
  end

  private

  def request_params
    params.permit(:request_type, :user_id, :request, appsflyer_attributes: [:advertising_id])
  end
end
