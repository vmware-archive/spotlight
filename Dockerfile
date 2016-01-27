FROM ruby:2.3.0

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev

RUN mkdir /spotlight
WORKDIR /spotlight
ADD Gemfile /spotlight/Gemfile
ADD Gemfile.lock /spotlight/Gemfile.lock
RUN bundle install
ADD . /spotlight
