require 'rack/cors'

Rails.application.config.middleware.insert_before 0, 'Rack::Cors' do
  allow do
    origins ENV.fetch('WEB_HOST')
    resource '*',
             headers: :any,
             methods: [:get, :post, :delete, :put, :options]
  end
end
