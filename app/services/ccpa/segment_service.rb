module Ccpa
  class SegmentServiceError < StandardError; end

  class SegmentService
    def initialize(external_request)
      @external_request = external_request
      @user_id = external_request.request.external_user_identifier
      @request_type = external_request.request.request_type.to_sym
      @integration = external_request.integration
    end

    def self.perform(external_request)
      new(external_request).perform
    end

    def perform
      case @request_type
      when :deletion
        perform_delete
      end
    end

    def perform_delete
      begin
        response = HTTParty.post(
          endpoint,
          headers: header,
          body: body
        )

        if response.code.to_s =~ /2\d\d/
          @external_request.complete!
        else
          @external_request.fail_with_error("Segment error deleting user #{@user_id}: #{response.code} - #{response.parsed_response['error']}")
        end
      rescue StandardError => e
        error_message = "Unable to delete Segment data for user: #{@user_id}. Error: #{e.inspect}"
        @external_request.fail_with_error(error_message)
        Rails.logger.error error_message
      end
    end

    def header
      {
        "Authorization": "Bearer #{@integration.api_key}",
        "Content-Type" => "application/json"
      }
    end

    def body
      {
        "regulation_type": "Suppress_With_Delete",
        "attributes": {  "name": "userId", "values": [ "#{@user_id}" ] }
      }.to_json
    end

    def endpoint
      "#{ENV['SEGMENT_API_URL']}/#{@integration.workspace_name}/regulations"
    end
  end
end
