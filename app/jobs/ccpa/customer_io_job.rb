module Ccpa
  class CustomerIoJob < ApplicationJob
    def perform(external_request)
      Ccpa::CustomerIoService.perform(external_request)
    end
  end
end
