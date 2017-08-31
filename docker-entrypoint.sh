#!/bin/sh

SECRET=$SECRET_KEY_BASE

if [ -z $SECRET ]; then
  echo "PLEASE SET ENV SECRET_KEY_BASE"
  exit 1
fi

cd /publify

bundle exec rake db:setup db:migrate db:seed assets:precompile
bundle exec rails s
