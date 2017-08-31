# FROM joenyland/ruby-alpine-therubyracer
FROM usualoma/ruby-with-therubyracer:2.4.0-alpine

RUN apk --update add git build-base ruby-dev sqlite-dev

ENV RAILS_ENV production

RUN gem install bundler


# RUN git clone https://github.com/publify/publify.git /publify
COPY . /publify

WORKDIR /publify

RUN cp config/database.yml.sqlite config/database.yml

RUN bundle config disable_checksum_validation true
RUN bundle install

ENTRYPOINT ["/publify/docker-entrypoint.sh"]
