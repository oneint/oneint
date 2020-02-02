require 'mixpanel-ruby'
module Ccpa
  class MixpanelService
    #https://developer.mixpanel.com/docs/managing-personal-data
    def initialize(external_request)
      @external_request = external_request
      @integration = external_request.integration
      @request_type = external_request.request.request_type
    end

    def self.perform(ccpa_request)
      new(ccpa_request).perform
    end

    def perform
      case @request_type
      when 'deletion'
        perform_delete
      when 'export'
        perform_export
      end
      true
    end

    def refresh_status
      key = @integration.api_key
      url = if @request_type == 'deletion'
        "#{ENV['MIXPANEL_DELETION_URL']}/#{@external_request.external_task_id}?token=#{key}"
      else
        "#{ENV['MIXPANEL_RETRIEVAL_URL']}/#{@external_request.external_task_id}?token=#{key}"
      end
      begin
        response = HTTParty.get(url,
          headers: headers,
          body: {distinct_ids: [@external_request.request.external_user_identifier.to_s].to_json})
        if response.parsed_response['status'] == 'ok' && response.parsed_response['results']
          result = response.parsed_response['results']
          case result['status']
          when 'SUCCESS'
            @external_request.status = :completed
            if @request_type == 'export'
              export_file = ExportFile.new(external_request: @external_request)
              export_file.file_remote_url = result['result']
              export_file.save!
            end
          when 'FAILURE'
            @external_request.status = :failed
          when 'REVOKED'
            @external_request.status = :canceled
          end
          @external_request.save
        end
      rescue StandardError => e
        Rails.logger.error "Error while refreshing status in Mixpanel for external request: #{@external_request.id}: #{e}"
      end
    end

    private

    def perform_delete
      key = @integration.api_key
      begin
        response = HTTParty.post("#{ENV['MIXPANEL_DELETION_URL']}?token=#{key}", headers: headers, body: {distinct_ids: [@external_request.request.external_user_identifier.to_s].to_json})
        if response.parsed_response['status'] == 'ok'
          @external_request.status = :processing
          @external_request.external_task_id = response.parsed_response['results']['task_id']
          @external_request.save
        else
          @external_request.fail_with_error("Error while trying to export data from mixpanel. Errors: #{response.parsed_response['error']['error']}")
        end
      rescue StandardError => e
        @external_request.fail_with_error("Error during a request to Mixpanel: #{e.inspect}")
      end
    end

    def perform_export
      begin
        url = "#{ENV['MIXPANEL_RETRIEVAL_URL']}?token=#{@integration.api_key}"
        response = HTTParty.post(url, headers: headers, body: {distinct_id: @external_request.request.external_user_identifier.to_s.to_json})
        if response.parsed_response['status'] == 'ok'
          @external_request.status = :processing
          @external_request.external_task_id = response.parsed_response['results']['task_id']
          @external_request.save
        else
          @external_request.fail_with_error(
            "Error while trying to export data from mixpanel. Errors: #{response.parsed_response['error']['error']}"
          )
        end
      rescue StandardError => ex
        Rails.logger.error "Unable to export Mixpanel data for external request #{@external_request.id}. Error: #{ex.inspect}"
      end
    end

    def headers
      {Authorization: "Bearer #{@integration.oauth_token}"}
    end
  end
end
