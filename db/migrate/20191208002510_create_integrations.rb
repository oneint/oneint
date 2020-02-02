class CreateIntegrations < ActiveRecord::Migration[6.0]
  def change
    create_table :integrations do |t|
      t.string :name
      t.references :application
      t.references :workspace
      t.string :description
      t.string :api_key
      t.string :site_id
      t.string :oauth_token

      t.timestamps
    end
  end
end
