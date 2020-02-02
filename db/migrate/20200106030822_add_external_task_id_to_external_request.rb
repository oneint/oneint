class AddExternalTaskIdToExternalRequest < ActiveRecord::Migration[6.0]
  def change
    add_column :external_requests, :external_task_id, :string
  end
end
