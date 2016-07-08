#!/bin/bash

WORK_DIR=`pwd`
GEMS_FOLDER=$WORK_DIR/gem-bundle

mkdir -p $GEMS_FOLDER


GEMS_CACHE=$WORK_DIR/gem-cache
OLD_BUNDLE_HASH=`ls $GEMS_CACHE`

if [ -d $GEMS_CACHE/$OLD_BUNDLE_HASH/gem-bundle/ruby ]
then
  mv $GEMS_CACHE/$OLD_BUNDLE_HASH/gem-bundle/ruby $GEMS_FOLDER/ruby
fi

cd $WORK_DIR/spotlight-git
cp config/database-docker.yml config/database.yml

gem install bundler
bundle install --path $GEMS_FOLDER

RAILS_ENV=test bundle exec rake db:drop db:create db:migrate
bundle exec rake spec

exit 0