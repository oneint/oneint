class Application < ApplicationRecord
  def mixpanel?
    self.name.downcase == 'mixpanel'
  end

  def customerio?
    self.name.downcase == 'customer.io'
  end

  def segment?
    self.name.downcase == 'segment'
  end

  def appsflyer?
    self.name.downcase == 'appsflyer'
  end

  def custom?
    self.name.downcase == 'custom webhook'
  end
end
