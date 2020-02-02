class AddAppsflyerFieldsToRequest < ActiveRecord::Migration[6.0]
  def change
    add_column :requests, :appsflyer_platforms, :text, array: true
    add_column :requests, :appsflyer_advertising_id, :string
  end
end
