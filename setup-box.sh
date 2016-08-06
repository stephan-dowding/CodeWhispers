#!/bin/sh -e

sudo apt-get update
curl -sL https://deb.nodesource.com/setup_5.x | sudo -E bash -
sudo apt-get install -y nodejs build-essential mongodb nginx git fcgiwrap libkrb5-dev
sudo npm install -g pm2 coffee-script

sudo rm -f /etc/nginx/sites-enabled/*

sudo cp /vagrant/nginx/whisper /etc/nginx/sites-available/whisper
sudo ln -s /etc/nginx/sites-available/whisper /etc/nginx/sites-enabled/whisper

sudo service nginx restart

git config --global user.email "whisper@mailinator.com"
git config --global user.name "whisper"
git config --global push.default simple

sudo git init --bare /srv/git/whisper.git --shared

sudo chgrp -R www-data /srv/git

cd /srv/git/whisper.git
sudo git config http.receivepack true
sudo git config receive.denynonfastforwards false

mkdir /vagrant/git-master
cp -R /vagrant/initialGit-Ruby/* /vagrant/git-master/

cd /vagrant/git-master
git init
git remote add origin http://localhost/git/whisper.git
git add --all
git commit -m "initial commit"
git push -u origin master

sudo ln -s /vagrant/git-hooks/update /srv/git/whisper.git/hooks

cd /vagrant
npm install
sudo pm2 start app.coffee -n whisper
sudo pm2 startup systemd

wget --tries 10 --retry-connrefused --post-data '{"number": 0}' --header 'Content-Type:application/json' -qO- http://localhost:3000/round
