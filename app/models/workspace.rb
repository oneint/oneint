class Workspace < ApplicationRecord
  has_many :integrations
  has_many :applications, through: :integrations
  has_many :requests

  validates :api_key, uniqueness: true

  before_create :generate_api_and_private_keys
  attr_encrypted :private_key, key: ENV['SECRET_KEY_FOR_ENCRYPTION']

  def generate_api_and_private_keys
    self.api_key = SecureRandom.base58(128)
    ecdsa_key = OpenSSL::PKey::EC.new 'secp384r1'
    self.private_key = ecdsa_key.generate_key.to_pem
    ecdsa_public = OpenSSL::PKey::EC.new ecdsa_key
    ecdsa_public.private_key = nil
    self.public_key = ecdsa_public.to_pem
  end
end
