#!/bin/bash

WORK_DIR=`pwd`
GEMS_FOLDER=$WORK_DIR/gem-cache

mkdir -p $GEMS_FOLDER

cd spotlight-git
cp config/database-docker.yml config/database.yml

gem install bundler
bundle install --path $GEMS_FOLDER

RAILS_ENV=test bundle exec rake db:drop db:create db:migrate
bundle exec rake spec

exit 0