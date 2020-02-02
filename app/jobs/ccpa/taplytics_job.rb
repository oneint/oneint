module Ccpa
  class TaplyticsJob < ApplicationJob
    def perform(external_request)
      Ccpa::TaplyticsService.perform(external_request)
    end
  end
end
