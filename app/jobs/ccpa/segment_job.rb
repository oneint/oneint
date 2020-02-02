module Ccpa
  class SegmentJob < ApplicationJob
    def perform(external_request)
      Ccpa::SegmentService.perform(external_request)
    end
  end
end
