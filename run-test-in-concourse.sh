#!/bin/bash

WORK_DIR=`pwd`
GEMS_FOLDER=$WORK_DIR/bundle

# Recover cache folder
mkdir -p $GEMS_FOLDER

CACHE_FOLDER=$WORK_DIR/build-cache

echo "Checking for [$CACHE_FOLDER/bundle/ruby]..."
if [ -d $CACHE_FOLDER/bundle/ruby ]
then
  echo "Found [$CACHE_FOLDER/bundle/ruby]. Moving ruby folder."
  mv $CACHE_FOLDER/bundle/ruby $GEMS_FOLDER/ruby
else
  echo "Not found ($CACHE_FOLDER/bundle/ruby)."
fi

# Run tests
cd $WORK_DIR/spotlight-git
cp config/database-docker.yml config/database.yml

gem install bundler
bundle install --path $GEMS_FOLDER

RAILS_ENV=test bundle exec rake db:drop db:create db:migrate
bundle exec rake spec