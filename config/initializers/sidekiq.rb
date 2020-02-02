require 'sidekiq'
require 'sidekiq/web'
require 'sidekiq/api'

Sidekiq::Extensions.enable_delay!
Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
  [user, password] == [ENV.fetch('SIDEKIQ_USERNAME'), ENV.fetch('SIDEKIQ_PASSWORD')]
end

Sidekiq.configure_server do |config|
  config.redis = { size: 20 } unless Rails.env.development?
end

Sidekiq.configure_client do |config|
  config.redis = { size: 1 }
end