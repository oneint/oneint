class Integration < ApplicationRecord
  belongs_to :workspace
  belongs_to :application

  validates_presence_of :api_key, unless: -> { application.custom? }
  validates_presence_of :description
  validate :validate_customerio_attributes
  validate :validate_mixpanel_attributes
  validate :validate_segment_attributes
  validate :validate_appsflyer_attributes

  attr_encrypted :api_key, key: ENV['SECRET_KEY_FOR_ENCRYPTION']
  attr_encrypted :additional_configuration_options, key: ENV['SECRET_KEY_FOR_ENCRYPTION'], marshal: true

  def oauth_token
    self.additional_configuration_options && self.additional_configuration_options['oauth_token']
  end

  def site_id
    self.additional_configuration_options && self.additional_configuration_options['site_id']
  end

  def workspace_name
    self.additional_configuration_options && self.additional_configuration_options['workspace_name']
  end

  def property_id
    self.additional_configuration_options && self.additional_configuration_options['property_id']
  end

  def platform
    self.additional_configuration_options && self.additional_configuration_options['platform']
  end

  def url
    self.additional_configuration_options && self.additional_configuration_options['url']
  end

private

  def validate_customerio_attributes
    return true unless self.application.customerio?
    if site_id.blank?
      errors.add(:site_id, "can't be blank")
    end
  end

  def validate_mixpanel_attributes
    return true unless self.application.mixpanel?
    if oauth_token.blank?
      errors.add(:oauth_token, "can't be blank")
    end
  end

  def validate_segment_attributes
    return true unless self.application.segment?
    if workspace_name.blank?
      errors.add(:workspace_name, "can't be blank")
    end
  end

  def validate_appsflyer_attributes
    return true unless self.application.appsflyer?
    errors.add(:property_id, "can't be blank") if property_id.blank?
    errors.add(:platform, "can't be blank") if platform.blank?

    if !%w(android ios fire microsoft).include?(platform)
      errors.add(:platform, "has invalid value")
    end
  end
end
