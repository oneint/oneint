class WebhooksController < ApplicationController
  skip_before_action :authenticate_user!

  def appsflyer
    external_request = ExternalRequest.find_by(external_task_id: params[:subject_request_id])
    external_request.update(status: params[:request_status])

    if external_request.completed?
      case external_request.request.request_type.to_sym
      when :export
        Ccpa::AppsflyerService.new(external_request).upload_export_file
      end
    end

    head :ok
  end
end
