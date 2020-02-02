class CreateExternalRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :external_requests do |t|
      t.references :request, null: false, foreign_key: true
      t.references :integration, null: false, foreign_key: true
      t.string :status, default: 0
      t.string :error
      t.string :file_url

      t.timestamps
    end
  end
end
