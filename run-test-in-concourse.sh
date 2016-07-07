#!/bin/bash

gem install bundler

cd spotlight-git
bundle install

# RAILS_ENV=test bundle exec rake db:drop db:create db:migrate
# bundle exec rake spec