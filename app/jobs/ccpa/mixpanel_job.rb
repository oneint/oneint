module Ccpa
  class MixpanelJob < ApplicationJob
    def perform(external_request, refresh_status: false)
      if refresh_status
        Ccpa::MixpanelService.new(external_request).refresh_status
      else
        Ccpa::MixpanelService.perform(external_request)
      end
    end
  end
end
