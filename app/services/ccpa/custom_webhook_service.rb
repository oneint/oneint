module Ccpa
  class CustomWebhookService
    def initialize(external_request)
      @external_request = external_request
      @integration = external_request.integration
      @request_type = external_request.request.request_type
    end

    def self.perform(external_request)
      new(external_request).perform
    end

    def perform
      perform_request
    end

    def refresh_status
      begin
        json = {
          task_id: @external_request.external_task_id,
          request_id: @external_request.request.id
        }
        response = HTTParty.get(@integration.url, body: {token: generate_jwt(json)})
        case response.parsed_response['status']
        when 'completed'
          @external_request.status = :completed
          if @request_type == 'export'
            export_file = ExportFile.new(external_request: @external_request)
            export_file.file_remote_url = response.parsed_response['file_url']
            export_file.save!
          end
        when 'failure'
          @external_request.status = :failed
          @external_request.error = response.parsed_response["error"]
        end
        @external_request.save
      rescue StandardError => e
        Rails.logger.error "Error while refreshing status for external request: #{@external_request.id}: #{e}"
      end
    end
  
    private

    def perform_request
      begin
        json = {
          request_type: @request_type,
          user_identifier: @external_request.request.external_user_identifier,
          request_id: @external_request.request.id
        }
        response = HTTParty.post(@integration.url, body: {token: generate_jwt(json)})
        if response.parsed_response['status'] == 'ok'
          @external_request.status = :processing
          @external_request.external_task_id = response.parsed_response['task_id']
          @external_request.save
        else
          @external_request.fail_with_error("Error while trying to export data from #{@integration.description}. Errors: #{response.parsed_response['error']}")
        end
      rescue StandardError => e
        @external_request.fail_with_error("Error during a request to #{@integration.description}: #{e.inspect}")
      end
    end

    def generate_jwt(payload)
      private_key = OpenSSL::PKey::EC.new @integration.workspace.private_key
      token = JWT.encode payload, private_key, 'ES384'
    end
  end
end
