module Ccpa
  class AppsflyerService
    #https://support.appsflyer.com/hc/en-us/articles/360000811585-GDPR-and-CCPA-compliance-using-APIs-#gdpr-requests-api
    def initialize(external_request)
      @external_request = external_request
      @integration = external_request.integration
      @request_type = external_request.request.request_type
    end

    def self.perform(external_request)
      new(external_request).perform
    end

    def perform
      body = request_body

      response = HTTParty.post(api_url, headers: headers, body: body.to_json)
      if response.parsed_response && response.parsed_response['subject_request_id']
        @external_request.status = :processing
        @external_request.external_task_id = response.parsed_response['subject_request_id']
        @external_request.save
      else
        @external_request.fail_with_error("Error while trying to export data from appsflyer. Errors: #{response.parsed_response['error']['message']}")
      end
    end

    def refresh_status
      api_token = @integration.api_key
      response = HTTParty.get("#{ENV['APPSFLYER_API_URL']}/#{@external_request.external_task_id}?api_token=#{api_token}")
      if response['Request_status']
        case response['Request_status']
        when 'completed'
          @external_request.status = :completed
        when 'canceled'
          @external_request.status = :canceled
        end
        @external_request.save
      end
    end

    def upload_export_file
      download_url = "#{ENV["APPSFLYER_DOWNLOAD_URL"]}/#{@external_request.external_task_id}?api_token=#{@integration.api_key}"
      begin
        export_file = ExportFile.new(external_request: @external_request)
        export_file.file = open(download_url).flush
        export_file.save!
        @external_request.complete!
      rescue StandardError => error
        @external_request.fail_with_error("Can't upload the file. Error: #{error.inspect}")
      end
    end

    private

    def api_url
      api_token = @integration.api_key
      "#{ENV['APPSFLYER_API_URL']}?api_token=#{api_token}"
    end

    def headers
      {"Content-Type": "application/json", "Accept": "application/json"}
    end

    def subject_request_type
      case @request_type.to_sym
      when :deletion then 'erasure'
      when :export then 'portability'
      end
    end

    def request_body
      #TODO: Needs to be passed from user
      property_id = @integration.property_id

      {
        subject_request_id: SecureRandom.uuid,
        subject_request_type: subject_request_type,
        submitted_time: Time.zone.now.rfc3339,
        subject_identities: [{
          identity_type: "#{@integration.platform}_advertising_id",
          identity_value: @external_request.request.appsflyer_advertising_id,
          identity_format: 'raw'
        }],
        property_id: property_id,
        status_callback_urls: ["#{ENV['BASE_URL']}/webhooks/appsflyer"]
      }
    end
  end
end
