module Ccpa
  class CustomerIoService
    #https://customer.io/docs/api/#apitrackcustomerssuppress_add
    def initialize(external_request)
      @external_request = external_request
      @integration = external_request.integration
      @request_type = external_request.request.request_type.to_sym
    end

    def self.perform(external_request)
      new(external_request).perform
    end

    def perform
      case @request_type
      when :deletion
        perform_delete
      when :export
        perform_export
      end
    end

    private

    def perform_delete
      customerio.suppress(external_user_identifier)
      @external_request.complete!
    end

    def perform_export
      upload_export_file(customer_io_data)

      @external_request.complete!
    rescue StandardError => exception
      external_request.fail_with_error("Customer.io export error. Errors: #{exception.message}")
      Rails.logger.error "Unable to export user data for Customer.io data. Error: #{exception.inspect}"
    end

    def customer_io_data
      attributes = data_for(:attributes)
      activities = data_for(:activities)
      messages   = data_for(:messages)

      {
        customer_io_export: {
          customer_attributes: attributes["customer"],
          activities: activities["activities"],
          messages: messages["messages"]
        }
      }
    end

    def auth
      { username: @integration.site_id, password: @integration.api_key }
    end

    def data_for(resource)
      response = HTTParty.get(endpoint_for(resource), basic_auth: auth)
      raise "Get #{resource} request failed with status #{response.code}. Response: #{response.inspect}" unless response.code == 200
      response.parsed_response
    end

    def endpoint_for(resource)
      [ENV['CUSTOMERIO_API_URL'], 'customers', external_user_identifier, resource].join('/')
    end

    def external_user_identifier
      @external_request.request.external_user_identifier
    end

    def upload_export_file(file_data)
      json_file = Tempfile.new(["customer_io_#{@external_request.id}", ".json"])
      File.open(json_file,"w") { |f| f.write(JSON.pretty_generate(file_data)) }
      export_file = ExportFile.new(external_request: @external_request)
      export_file.file = json_file.flush
      export_file.save!
    end

    def customerio
      Customerio::Client.new(auth[:username], auth[:password])
    end
  end
end
