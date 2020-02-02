module Ccpa
  class TaplyticsService

    def initialize(external_request)
      @external_request = external_request
      @request_type = external_request.request.request_type.to_sym
      @integration = external_request.integration
      @user_id = external_request.request.external_user_identifier
    end

    def self.perform(ccpa_request)
      new(ccpa_request).perform
    end

    def perform
      case @request_type
      when :deletion
        perform_delete
      end
    end

    private

    def perform_delete
      taplytics_id = taplytics_user_id
      if taplytics_id.nil?
        @external_request.fail_with_error("Can't find Taplytics user id for: #{@user_id}")
        return true
      end

      api_url = ENV.fetch('TAPLYTICS_REST_API_URL') + "/#{taplytics_id}"
      response = HTTParty.delete(api_url, headers: headers )
      if response.response.code.to_s =~ /2\d\d/
        @external_request.complete!
        return true
      end

      @external_request.fail_with_error("#{response.response.code} - #{response.response.message}")
    rescue StandardError => e
      error_message = "Taplytics error deleting user #{@user_id}: #{e.message}"
      Rails.logger.error(error_message)
      @external_request.fail_with_error(error_message)
    end

    def perform_export
    end

    def headers
      { "X-Access-Token" => @integration.api_key, 'Content-Type' => 'application/json' }
    end

    def taplytics_user_id
      api_url = ENV.fetch('TAPLYTICS_REST_API_URL') + "?user_id=#{@user_id}"
      response = HTTParty.get(api_url, headers: headers )
      response.parsed_response["id"]
    end
  end
end
