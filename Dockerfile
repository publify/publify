FROM ubuntu:latest

RUN export LC_ALL=en_US.UTF-8
RUN export LANG=en_US.UTF-8
RUN export LANGUAGE=en_US.UTF-8

ENV HOME /root
ENV PATH $HOME/.rbenv/bin:$HOME/.rbenv/shims:$PATH
ENV SHELL /bin/bash

RUN apt-get -q update \
  && DEBIAN_FRONTEND=noninteractive apt-get -q -y install wget locales

RUN locale-gen en_US.UTF-8
RUN update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 LANGUAGE=en_US.UTF-8
RUN dpkg-reconfigure locales --frontend=noninteractive
RUN export LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 LANGUAGE=en_US.UTF-8
ENV LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 LANGUAGE=en_US.UTF-8

RUN wget -O - https://github.com/sstephenson/rbenv/archive/master.tar.gz \
  | tar zxf - \
  && mv rbenv-master $HOME/.rbenv
RUN wget -O - https://github.com/sstephenson/ruby-build/archive/master.tar.gz \
  | tar zxf - \
  && mkdir -p $HOME/.rbenv/plugins \
  && mv ruby-build-master $HOME/.rbenv/plugins/ruby-build

RUN echo 'eval "$(rbenv init -)"' >> $HOME/.profile
RUN echo 'eval "$(rbenv init -)"' >> $HOME/.bashrc


ENV RUBY_VERSION 2.2.5

RUN apt-get update -q \
  && apt-get -q -y install autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev \
  && rbenv install $RUBY_VERSION \
  && rbenv global $RUBY_VERSION
RUN gem install --no-ri --no-rdoc bundler
RUN rbenv rehash

RUN apt install -q -y nodejs npm libssl1.0.0 libssl-dev libreadline-dev zlib1g-dev libxml2 libxml2-dev libsqlite3-dev libmysqlclient-dev libpq-dev
COPY . /publify
RUN locale

WORKDIR /publify

RUN bundle install

RUN apt-get autoremove -y && apt-get purge -y -q autoconf bison build-essential libssl-dev zlib1g-dev && rm -rf /var/lib/apt/lists \
  && apt-get -q clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN bundle exec rake db:setup && bundle exec rake db:migrate && bundle exec rake db:seed && bundle exec rake assets:precompile

ENTRYPOINT ["bundle", "exec", "rails", "s"]
