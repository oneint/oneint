class AddContactToEmailSubscriber < ActiveRecord::Migration[6.0]
  def change
    add_column :email_subscribers, :first_name, :string
    add_column :email_subscribers, :company_name, :string
    add_column :email_subscribers, :phone, :string
  end
end
