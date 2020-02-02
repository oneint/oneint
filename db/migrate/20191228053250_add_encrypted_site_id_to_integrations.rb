class AddEncryptedSiteIdToIntegrations < ActiveRecord::Migration[6.0]
  def change
    add_column :integrations, :encrypted_site_id, :string
    add_column :integrations, :ecnrypted_site_id_iv, :string
  end
end
