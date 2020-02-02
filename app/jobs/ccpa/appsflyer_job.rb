module Ccpa
  class AppsflyerJob < ApplicationJob
    def perform(external_request, refresh_status: false)
      if refresh_status
        Ccpa::AppsflyerService.new(external_request).refresh_status
      else
        Ccpa::AppsflyerService.perform(external_request)
      end
    end
  end
end
