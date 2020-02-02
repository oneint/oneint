class ExternalRequest < ApplicationRecord
  belongs_to :request
  belongs_to :integration
  has_many :export_files

  enum status: %i[enqueued processing completed failed canceled]

  def mixpanel?
    integration.application.name.downcase == 'mixpanel'
  end

  def appsflyer?
    integration.application.name.downcase == 'appsflyer'
  end

  def complete!
    self.status = :completed
    self.save
  end

  def initiate_request_execution
    case integration.application.name.downcase
    when 'appsflyer'
      Ccpa::AppsflyerJob.perform_later(self)
    when 'customer.io'
      Ccpa::CustomerIoJob.perform_later(self)
    when 'mixpanel'
      Ccpa::MixpanelJob.perform_later(self)
    when 'taplytics'
      Ccpa::TaplyticsJob.perform_later(self)
    when 'segment'
      Ccpa::SegmentJob.perform_later(self)
    when 'custom webhook'
      Ccpa::CustomWebhookJob.perform_later(self)
    end
  end

  def fail_with_error(error)
    self.status = :failed
    self.error = error
    self.save
  end

end
