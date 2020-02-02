class CreateRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :requests do |t|
      t.references :workspace, null: false, foreign_key: true
      t.string :request_type
      t.string :external_user_identifier
      t.string :status
      t.string :error

      t.timestamps
    end
  end
end
