class AddEncryptedApiKeyToIntegration < ActiveRecord::Migration[6.0]
  def change
    change_table(:integrations) do |t|
      t.string :encrypted_api_key unless column_exists?(:integrations, :encrypted_api_key)
      t.string :encrypted_api_key_iv unless column_exists?(:integrations, :encrypted_api_key_iv)
      t.string :encrypted_oauth_token unless column_exists?(:integrations, :encrypted_oauth_token)
      t.string :encrypted_oauth_token_iv unless column_exists?(:integrations, :encrypted_oauth_token_iv)
      t.remove :api_key
      t.remove :oauth_token
    end
  end
end
