class AddPrivateKeyAndEncryptApiKeyToWorkspace < ActiveRecord::Migration[6.0]
  def up
    add_column :workspaces, :encrypted_private_key, :text unless column_exists?(:workspaces, :encrypted_private_key)
    add_column :workspaces, :encrypted_private_key_iv, :string unless column_exists?(:workspaces, :encrypted_private_key_iv)
    add_column :workspaces, :public_key, :string unless column_exists?(:workspaces, :public_key)

    add_index :workspaces, :encrypted_private_key_iv, unique: true unless index_exists?(:workspaces, :encrypted_private_key_iv)
  end

  def down
    remove_column :workspaces, :encrypted_private_key, :text if column_exists?(:workspaces, :encrypted_private_key)
    remove_column :workspaces, :encrypted_private_key_iv, :string if column_exists?(:workspaces, :encrypted_private_key_iv)
    remove_column :workspaces, :public_key, :string if column_exists?(:workspaces, :public_key)
    remove_index :workspaces, :encrypted_private_key_iv if index_exists?(:workspaces, :encrypted_private_key_iv)
  end
end
