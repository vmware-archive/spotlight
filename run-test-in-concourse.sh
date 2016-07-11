#!/bin/bash

WORK_DIR=`pwd`
GEMS_FOLDER=$WORK_DIR/bundle

# Recover cache folder
mkdir -p $GEMS_FOLDER

CACHE_FOLDER=$WORK_DIR/build-cache
PREV_CACHE_HASH=`ls $CACHE_FOLDER`

echo "Checking for [$CACHE_FOLDER/$PREV_CACHE_HASH/bundle/ruby]..."
if [ -d $CACHE_FOLDER/$PREV_CACHE_HASH/bundle/ruby ]
then
  echo "Found [$CACHE_FOLDER/$PREV_CACHE_HASH/bundle/ruby]. Moving ruby folder."
  mv $CACHE_FOLDER/$PREV_CACHE_HASH/bundle/ruby $GEMS_FOLDER/ruby
else
  echo "Not found ($CACHE_FOLDER/$PREV_CACHE_HASH/bundle/ruby)."
fi

# Run tests
cd $WORK_DIR/spotlight-git
cp config/database-docker.yml config/database.yml

gem install bundler
bundle install --path $GEMS_FOLDER

RAILS_ENV=test bundle exec rake db:drop db:create db:migrate
bundle exec rake spec