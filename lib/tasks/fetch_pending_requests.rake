task :fetch_pending_requests => :environment do
  ExternalRequest.processing.each do |external_request|
    if external_request.mixpanel?
      Ccpa::MixpanelJob.perform_later(external_request, refresh_status: true)
    elsif external_request.appsflyer?
      Ccpa::AppsflyerJob.perform_later(external_request, refresh_status: true)
    elsif external_request.custom?
      Ccpa::CustomWebhookJob.perform_later(external_request, refresh_status: true)
    end
  end
end