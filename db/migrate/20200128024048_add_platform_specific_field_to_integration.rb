class AddPlatformSpecificFieldToIntegration < ActiveRecord::Migration[6.0]
  def up
    add_column :integrations, :encrypted_additional_configuration_options, :json unless column_exists?(:integrations, :encrypted_additional_configuration_options)
    add_column :integrations, :encrypted_additional_configuration_options_iv, :json unless column_exists?(:integrations, :encrypted_additional_configuration_options_iv)
    remove_column :integrations, :encrypted_oauth_token if column_exists?(:integrations, :encrypted_oauth_token)
    remove_column :integrations, :appsflyer_platform if column_exists?(:integrations, :appsflyer_platform)
    remove_column :integrations, :encrypted_oauth_token_iv if column_exists?(:integrations, :encrypted_oauth_token_iv)
    remove_column :integrations, :property_id if column_exists?(:integrations, :property_id)
    remove_column :integrations, :encrypted_site_id if column_exists?(:integrations, :encrypted_site_id)
    remove_column :integrations, :ecnrypted_site_id_iv if column_exists?(:integrations, :ecnrypted_site_id_iv)
    remove_column :integrations, :workspace_name if column_exists?(:integrations, :workspace_name)
    remove_column :integrations, :api_key if column_exists?(:integrations, :api_key)
    remove_column :integrations, :site_id if column_exists?(:integrations, :site_id)
  end

  def down
    remove_column :integrations, :encrypted_additional_configuration_options if column_exists?(:integrations, :encrypted_additional_configuration_options)
    remove_column :integrations, :encrypted_additional_configuration_options_iv if column_exists?(:integrations, :encrypted_additional_configuration_options_iv)
    add_column :integrations, :encrypted_oauth_token, :string unless column_exists?(:integrations, :encrypted_oauth_token)
    add_column :integrations, :appsflyer_platform, :string unless column_exists?(:integrations, :appsflyer_platform)
    add_column :integrations, :encrypted_oauth_token_iv, :string unless column_exists?(:integrations, :encrypted_oauth_token_iv)
    add_column :integrations, :property_id, :string unless column_exists?(:integrations, :property_id)
    add_column :integrations, :encrypted_site_id, :string unless column_exists?(:integrations, :encrypted_site_id)
    add_column :integrations, :ecnrypted_site_id_iv, :string unless column_exists?(:integrations, :ecnrypted_site_id_iv)
    add_column :integrations, :workspace_name, :string unless column_exists?(:integrations, :workspace_name)
  end
end
