class AddAppsflyerPlatformToIntegration < ActiveRecord::Migration[6.0]
  def change
    add_column :integrations, :appsflyer_platform, :string
  end
end
