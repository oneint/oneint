class ChangeEnumToBeIntegers < ActiveRecord::Migration[6.0]
  def change
    change_column :requests, :request_type, :integer
    change_column :requests, :status, :integer
    change_column :external_requests, :status, :integer
  end
end
