class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :validatable
  after_create :create_default_workspace

  has_many :workspaces

  validates :email, uniqueness: true
  validates :company_name, uniqueness: true

  def current_or_default_workspace(workspace_id=nil)
    workspace_id ? self.workspaces.find_by(id: workspace_id) : self.workspaces.first
  end

  private

  def create_default_workspace
    self.workspaces.create(name: 'Default workspace')
  end
end
