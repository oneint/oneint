class Api::BaseController < ApplicationController
  skip_forgery_protection

  def authenticate_user!
    return head 401 unless request.headers[:HTTP_API_KEY].present?
    return true if @workspace = Workspace.find_by(api_key: request.headers[:HTTP_API_KEY])
    head 401
  end
end