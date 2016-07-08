#!/bin/bash

WORK_DIR=`pwd`

mkdir -p $WORK_DIR/gems

cd spotlight-git
cp config/database-docker.yml config/database.yml

gem install bundler
bundle install --path $WORK_DIR/gems

RAILS_ENV=test bundle exec rake db:drop db:create db:migrate
bundle exec rake spec