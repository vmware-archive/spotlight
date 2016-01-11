# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require 'spec_helper'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

# Add additional requires below this line. Rails is not loaded until this point!
require 'factory_girl'

require 'capybara'
require 'capybara/rspec'
require 'selenium-webdriver'
require 'shoulda/matchers'
require 'database_cleaner'

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

Capybara.javascript_driver = :selenium

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  config.use_transactional_fixtures = false

  Capybara.default_driver = :rack_test
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = Capybara.current_driver != :rack_test ? :truncation : :transaction
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.infer_spec_type_from_file_location!
end
