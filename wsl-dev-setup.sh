###################################################
# Install RabbitMQ
###################################################

#!/bin/sh

sudo apt-get update -y

## Install prerequisites
sudo apt-get install curl gnupg -y

## Install RabbitMQ signing key
curl -fsSL https://github.com/rabbitmq/signing-keys/releases/download/2.0/rabbitmq-release-signing-key.asc | sudo apt-key add -

## Install apt HTTPS transport
sudo apt-get install apt-transport-https -y

## Add Bintray repositories that provision latest RabbitMQ and Erlang 21.x releases
sudo tee /etc/apt/sources.list.d/bintray.rabbitmq.list <<EOF
## Installs the latest Erlang 22.x release.
## Change component to "erlang-21.x" to install the latest 21.x version.
## "bionic" as distribution name should work for any later Ubuntu or Debian release.
## See the release to distribution mapping table in RabbitMQ doc guides to learn more.
deb https://dl.bintray.com/rabbitmq-erlang/debian bionic erlang
deb https://dl.bintray.com/rabbitmq/debian bionic main
EOF

## Update package indices
sudo apt-get update -y

## Install rabbitmq-server and its dependencies
sudo apt-get install rabbitmq-server -y --fix-missing
sudo service rabbitmq-server start

# rabbitmqctl add_user should be used to create a user, 
# rabbitmqctl set_permissions to grant the user the desired permissions and finally, 
# rabbitmqctl set_user_tags should be used to give the user management UI access permissions.
# Create admin user
sudo rabbitmqctl add_user ippo 321

# Tag the user with "administrator" for full management UI and HTTP API access
sudo rabbitmqctl set_user_tags ippo administrator

# Granting Permissions to a User
# First ".*" for read permission on every entity
# Second ".*" for write permission on every entity
# Third ".*" for configure permission on every entity
sudo rabbitmqctl set_permissions -p "/" "admin" ".*" ".*" ".*"

###################################################
# Install RabbitMQ Management Plugin
###################################################

rabbitmq-plugins enable rabbitmq_management

###################################################
# Install dependencies for Ruby and Rails
###################################################

sudo apt install curl -y
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

sudo apt-get update
sudo apt-get install git-core zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev software-properties-common libffi-dev nodejs yarn

###################################################
# Install Ruby
###################################################

cd
wget http://ftp.ruby-lang.org/pub/ruby/2.6/ruby-2.6.6.tar.gz
tar -xzvf ruby-2.6.6.tar.gz
cd ruby-2.6.6/
./configure
make
sudo make install
ruby -v

###################################################
# Install Bundler
###################################################

gem install bundler
bundle update

###################################################
# Install Rails
###################################################

gem install rails -v 5.2.4.2

###################################################
# Install Redis
###################################################

sudo apt install redis-server -y
sudo service redis-server start
sudo systemctl enable redis-server 

###################################################
# Install PostgreSQL
###################################################

sudo apt install postgresql-common -y
sudo sh /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh

sudo apt install postgresql postgresql-contrib libpq-dev -y
sudo service postgresql start
sudo systemctl enable postgresql

###################################################
# Create PostgreSQL user
###################################################

sudo -u postgres createuser ippo --superuser --createdb --echo 
sudo -u postgres psql -c "ALTER USER ippo PASSWORD '321'"
sudo -u postgres psql -c "CREATE DATABASE backend"

###################################################
# Install Nokogiri
###################################################

sudo apt-get install libgmp-dev -y
sudo apt-get install build-essential patch ruby-dev zlib1g-dev liblzma-dev -y
gem install nokogiri

###################################################
# Install Nginx + Passenger
###################################################

sudo apt-get install nginx -y

# Install our PGP key and add HTTPS support for APT
sudo apt-get install -y dirmngr gnupg
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
sudo apt-get install -y apt-transport-https ca-certificates

# Add our APT repository
sudo sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger focal main > /etc/apt/sources.list.d/passenger.list'
sudo apt-get update

# Install Passenger + Nginx module
sudo apt-get install -y libnginx-mod-http-passenger

sudo service nginx restart

###################################################

update-locale LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8
