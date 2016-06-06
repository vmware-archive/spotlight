#!/bin/bash

cd $(dirname $0)
set -e
export RAILS_ENV=test
export TZ=Asia/Singapore
cp -n env.sample .env
cp -n config/database-local.yml config/database.yml

####

function run-rb() {
    /etc/init.d/postgresql start
    echo -- Sleep 30
    sleep 30
    rake db:setup

    echo -- Ruby tests
    xvfb-run rspec $@
}

####

case "$1" in
    all)
        echo "-- Running all tests"
        run-rb
        ;;
    rb)
        run-rb
        ;;
    *)
        echo "No type specified. Please specify one of: all, js, rb, or integration" >&2
        exit 1
        ;;
esac
