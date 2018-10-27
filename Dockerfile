FROM ruby:2.5-alpine

RUN apk update && apk add build-base nodejs postgresql-dev postgresql-client

RUN mkdir /app
WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

ADD . /app

CMD puma -C config/puma.rb
