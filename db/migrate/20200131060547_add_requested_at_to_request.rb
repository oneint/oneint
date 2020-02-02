class AddRequestedAtToRequest < ActiveRecord::Migration[6.0]
  def change
    add_column :requests, :requested_at, :datetime
  end
end
