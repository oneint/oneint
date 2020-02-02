class CreateWorkspaces < ActiveRecord::Migration[6.0]
  def change
    create_table :workspaces do |t|
      t.string :name
      t.references :user
      t.string :api_key

      t.timestamps
    end
  end
end
