class Request < ApplicationRecord
  belongs_to :workspace
  has_many :external_requests

  enum request_type: %i[deletion export]
  enum status: %i[enqueued processing completed failed canceled]

  validates :external_user_identifier, presence: true
  validates :request_type, presence: true
  validate :at_least_one_integration_present

  after_create :create_external_requests
  before_create :set_requested_at, if: ->{ requested_at.nil? }

  private

  def at_least_one_integration_present
    self.errors.add(:base, "Please add at least one integration") if self.workspace.integrations.count == 0
  end

  def create_external_requests
    workspace.integrations.each do |integration|
      next if request_type == 'export' && %w(taplytics segment).include?(integration.application.name.downcase)
      external_request = external_requests.create(integration: integration)
      external_request.initiate_request_execution
    end
  end

  def set_requested_at
    self.requested_at = Time.current
  end
end
