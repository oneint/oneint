class AddAdditionalFieldsToIntegration < ActiveRecord::Migration[6.0]
  def change
    add_column :integrations, :property_id, :string
    add_column :integrations, :workspace_name, :string
  end
end
