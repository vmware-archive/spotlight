#!/bin/bash

WORK_DIR=`pwd`
GEMS_FOLDER=$WORK_DIR/bundle
ARCHIVES_FOLDER=$WORK_DIR/archives

# Recover cache folder
mkdir -p $GEMS_FOLDER
mkdir -p $ARCHIVES_FOLDER

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

echo "Checking for [$CACHE_FOLDER/$PREV_CACHE_HASH/archives/ruby.tar.gz]..."
if [ -d $CACHE_FOLDER/$PREV_CACHE_HASH/archives/ruby.tar.gz ]
then
  echo "Found [$CACHE_FOLDER/$PREV_CACHE_HASH/archives/ruby.tar.gz]. Untarring contents..."
  tar -xzf $CACHE_FOLDER/$PREV_CACHE_HASH/archives/ruby.tar.gz -C $GEMS_FOLDER/
else
  echo "Not found ($CACHE_FOLDER/$PREV_CACHE_HASH/archives/ruby.tar.gz)."
fi

# Run tests
cd $WORK_DIR/spotlight-git
cp config/database-docker.yml config/database.yml

gem install bundler
bundle install --path $GEMS_FOLDER

RAILS_ENV=test bundle exec rake db:drop db:create db:migrate
bundle exec rake spec

# Tarball the Rubies / Gems
tar -czf $ARCHIVES_FOLDER/ruby.tar.gz $GEMS_FOLDER/ruby

exit 0