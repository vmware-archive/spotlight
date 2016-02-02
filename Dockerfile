FROM ruby:2.3.0

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev

ENV RAILS_ENV production
ENV RACK_ENV production
ENV PORT 3000
ENV DB_USER postgres
ENV DB_HOST db
ENV DB_NAME spotlight_production

RUN mkdir /spotlight
WORKDIR /spotlight
ADD Gemfile /spotlight/Gemfile
ADD Gemfile.lock /spotlight/Gemfile.lock
RUN bundle install --without development test --jobs 8 --retry 6
ADD . /spotlight
COPY config/database-docker.yml config/database.yml
RUN rake assets:precompile RAILS_ENV=production
