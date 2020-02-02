class ChangeStatusDefaultOnRequests < ActiveRecord::Migration[6.0]
  def change
    change_column_default(:requests, :status, 0)
    change_column_default(:external_requests, :status, 0)
  end
end
