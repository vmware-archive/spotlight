#!/bin/bash

cd spotlight-git
cp config/database-docker.yml config/database.yml

gem install bundler
bundle install --local

RAILS_ENV=test bundle exec rake db:drop db:create db:migrate
bundle exec rake spec