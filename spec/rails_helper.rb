# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'

ENV['GOOGLE_API_CLIENT_ID'] = 'fake-api-id'
ENV['GOOGLE_API_CLIENT_SECRET'] = 'fake-api-secret'

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
require 'webmock/rspec'
require 'billy/capybara/rspec'
require 'vcr'

WebMock.disable_net_connect!(:allow_localhost => true)

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

# Capybara.javascript_driver = :selenium
Capybara.javascript_driver = :selenium_billy # Uses Firefox
Capybara.server_port = 8200

# Billy.configure do |c|
#     c.cache_request_body_methods = ['get', 'post', 'patch', 'put'] # defaults to ['post']
# end

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock
  config.ignore_localhost = true
  config.ignore_request do |request|
    request.headers.include?('Referer')
  end
end

def kill_zombie_children(parent_pid)
  # get a list of processes and children
  process_output = `ps -eo pid,ppid,args | grep #{parent_pid} | grep -iv grep`

  # break out column output into pid, parent_id, command
  matches = process_output.scan /^\s*(\d+)\s*(\d+)\s*(.*)$/
  return nil if matches.nil? || matches.empty?

  matches.each do |match|
    pid = match[0].to_i
    Process.kill "KILL", pid
  end
end

require 'socket'
RSpec.configure do |config|
  config.around(:each, type: :feature) do |example|
    WebMock.allow_net_connect!
    example.run
    WebMock.disable_net_connect!
  end

  config.before(:all, type: :feature) do |example|
    puts "#{Capybara.server_host}:#{Capybara.server_port}"
    next if $started_frontend_server
    puts "STARTING FRONTEND SERVER"
    $pid = Process.fork do
      $stdout.reopen("/dev/null")
      cmd = "cd ../spotlight-dashboard && npm install --only=production && API_HOST=http://localhost:#{Capybara.server_port} webpack -p && NODE_ENV=production PORT=8201 node server.js"
      exec(cmd)
      exit! 127
    end
    $started_frontend_server = true

    $not_connected = true
    $connect_timeout = Time.now + 120.seconds
    puts 'WAITING FOR FRONTEND SERVER...'
    while $not_connected do
      if Time.now > $connect_timeout
        puts "FAILED TO CONNECT"
        exit 1
      end

      begin
         Socket.tcp 'localhost', 8201
         $not_connected = false
      rescue Errno::ECONNREFUSED
        # Socket not able to connect yet, so wait a bit...
        sleep 0.1
      end
    end
  end

  config.after(:each, type: :feature) do
    errors = page.driver.browser.manage.logs.get(:browser)
    puts errors.map(&:message).join("\n") if errors.present?
  end

  def login_to_dashboard
    page.execute_script 'localStorage.setItem("authToken", "fake-auth-token"); window.location.reload();'
  end

  def click_add_widget
    click_link 'edit'
    click_link 'add'
  end

  config.after(:suite) do |example|
    if $started_frontend_server
      puts "KILLING FRONTEND SERVER"
      kill_zombie_children($pid)
    end
  end

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
