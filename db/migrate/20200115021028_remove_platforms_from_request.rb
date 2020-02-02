class RemovePlatformsFromRequest < ActiveRecord::Migration[6.0]
  def change
    remove_column :requests, :appsflyer_platforms, :text
  end
end
