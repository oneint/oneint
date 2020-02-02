module Ccpa
  class CustomWebhookJob < ApplicationJob
    def perform(external_request, refresh_status: false)
      if refresh_status
        Ccpa::CustomWebhookService.new(external_request).refresh_status
      else
        Ccpa::CustomWebhookService.perform(external_request)
      end
    end
  end
end
