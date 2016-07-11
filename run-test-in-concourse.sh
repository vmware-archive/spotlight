#!/bin/bash

WORK_DIR=`pwd`
GEMS_FOLDER=$WORK_DIR/bundle
ARCHIVES_FOLDER=$WORK_DIR/archives

# Recover cache folder
mkdir -p $GEMS_FOLDER
mkdir -p $ARCHIVES_FOLDER

GEMS_CACHE=$WORK_DIR/build-cache
OLD_BUNDLE_HASH=`ls $GEMS_CACHE`

if [ -d $GEMS_CACHE/$OLD_BUNDLE_HASH/bundle/ruby ]
then
  mv $GEMS_CACHE/$OLD_BUNDLE_HASH/bundle/ruby $GEMS_FOLDER/ruby
fi

if [ -d $GEMS_CACHE/$OLD_BUNDLE_HASH/archive/ruby.tar.gz ]
then
  tar -xzvf $GEMS_CACHE/$OLD_BUNDLE_HASH/archive/ruby.tar.gz -C $GEMS_FOLDER/
fi

# Run tests
cd $WORK_DIR/spotlight-git
cp config/database-docker.yml config/database.yml

gem install bundler
bundle install --path $GEMS_FOLDER

RAILS_ENV=test bundle exec rake db:drop db:create db:migrate
bundle exec rake spec

# Tarball the Rubies / Gems
tar -cvzf $ARCHIVES_FOLDER/ruby.tar.gz $GEMS_FOLDER/ruby

exit 0