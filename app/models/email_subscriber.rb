class EmailSubscriber < ApplicationRecord
  validates_presence_of :email
end
