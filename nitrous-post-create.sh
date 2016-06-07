#!/bin/bash
rm -rf ~/code/example

sudo apt-get update
sudo apt-get install -y --no-install-recommends imagemagick
sudo apt-get clean

cd ~/code/publify

# publify requires ruby 2.2.4
rbenv install 2.2.4
rbenv global 2.2.4

createdb publify_dev
createdb publify_tests
mv ~/code/publify/config/database.yml.postgresql ~/code/publify/config/database.yml

# bundle install
gem install bundler
bundle install

sed -i 's|  host: localhost||g' config/database.yml
sed -i 's|  port: 5432||g' config/database.yml
sed -i 's|  username: postgres||g' config/database.yml
sed -i 's|  password:||g' config/database.yml

rake db:setup
rake db:migrate
rake db:seed
rake assets:precompile
rake db:test:prepare
