# Annual Staffing Request Docker
# Based on https://docs.docker.com/compose/rails/

ARG username
FROM ruby:2.2.4
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir -p /apps/annual-staffing-request
WORKDIR /apps/annual-staffing-request
ADD Gemfile /apps/annual-staffing-request/Gemfile
ADD Gemfile.lock /apps/annual-staffing-request/Gemfile.lock
RUN bundle install
ADD . /apps/annual-staffing-request

