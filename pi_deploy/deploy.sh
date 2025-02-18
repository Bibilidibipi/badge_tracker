## Run this on the Raspberry Pi
## Before running this script, do the following:
## * Use Raspberry Pi Imager to flash SD card with Raspberry Pi OS Lite (64 bit) (10/22/24)
##      * with SSH and Wifi enabled, username: badge_tracker
## * Insert SD card in Pi, and power it up
## * SCP pi_deploy/deploy.sh (this script) to /tmp/deploy.sh
## * SCP pi_deploy/badge_tracker.service to /tmp/badge_tracker.service on Pi
## * SCP pi_deploy/apache.conf to /tmp/apache.conf on Pi
## * SSH to Pi
## * execute /tmp/deploy.sh with argument rails_master_key

die () {
    echo >&1 "$@"
    exit 1
}

[ "$#" -eq 1 ] || die "Specify rails_master_key as first parameter"

RAILS_MASTER_KEY=$1

sudo apt update
sudo apt upgrade -y
sudo apt install -y git libffi-dev libssl-dev libyaml-dev libz-dev nodejs

# Ruby
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
RUBY_CONFIGURE_OPTS="--disable-install-doc" rbenv install 3.3.5 --verbose
rbenv global 3.3.5
gem install bundler -v 2.5.22 --no-document

# Apache
sudo apt install -y apache2

# Rails App
echo 'export RAILS_ENV=production' >> ~/.bashrc
export RAILS_ENV=production
cd /var/www
sudo git clone https://github.com/Bibilidibipi/badge_tracker.git
sudo chown $(whoami) -R badge_tracker
cd badge_tracker
bundle config set without 'development test'
bundle config set deployment true
bundle install

# Master Key in perpetuity
echo "$RAILS_MASTER_KEY" > /var/www/badge_tracker/config/master.key

# PostgreSQL
sudo apt install -y postgresql libpq-dev
sudo -u postgres createuser -s badge_tracker
sudo -u postgres psql -c "ALTER USER badge_tracker WITH PASSWORD '$(bin/rails runner "p Rails.application.credentials.dig(:production, :database, :password)")';"

bin/rails db:create
bin/rails db:migrate
bin/rails assets:precompile

# systemd to run the app
sudo mv /tmp/badge_tracker.service /etc/systemd/system/badge_tracker.service
sudo chown root /etc/systemd/system/badge_tracker.service
sudo chmod 755 /etc/systemd/system/badge_tracker.service

## Enable the systemd process
sudo systemctl daemon-reload
sudo systemctl enable badge_tracker.service
sudo systemctl start badge_tracker.service

## Apache config file
sudo mv /tmp/apache.conf /etc/apache2/sites-available/001-badge_tracker.conf
sudo chown root /etc/apache2/sites-available/001-badge_tracker.conf
sudo chmod 644 /etc/apache2/sites-available/001-badge_tracker.conf

## Enable new Apache config
sudo a2enmod rewrite proxy proxy_http headers
sudo a2ensite 001-badge_tracker
sudo a2dissite 000-default
sudo systemctl restart apache2
