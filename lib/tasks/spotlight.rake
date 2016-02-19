namespace :spotlight do
  desc "Brings up the server and tests the features"
  task start_test_server: :environment do
    system "cp .env .env.bak"
    system "cp .env.feature_test .env && foreman start -f Procfile.test &"
  end

  desc "Stops test server"
  task stop_test_server: :environment do
    system "ps aux | grep -ie foreman | grep -v grep | awk '{print $2}' | xargs kill -9"
    system "mv .env.bak .env"
  end

  desc "Runs feature tests"
  task test_features: :environment do
    Rake::Task["spotlight:start_test_server"].invoke
    sleep 60 # npm install, start takes a while
    system "bundle exec rspec spec/features"
    Rake::Task["spotlight:stop_test_server"].invoke
  end

end
