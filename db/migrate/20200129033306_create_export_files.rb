class CreateExportFiles < ActiveRecord::Migration[6.0]
  def change
    create_table :export_files do |t|
      t.references :external_request, null: false, foreign_key: true
      t.text :file_data

      t.timestamps
    end
  end
end
