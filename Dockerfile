FROM ruby:2.4-alpine

RUN apk update && apk add git build-base ruby-dev sqlite-dev

RUN git clone https://github.com/publify/publify.git /publify

RUN gem install bundler

WORKDIR /publify

RUN cp config/database.yml.sqlite config/database.yml

RUN bundle install

RUN bundle exec rake db:setup



