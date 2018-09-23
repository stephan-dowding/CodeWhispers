#!/bin/sh -e

BASEPATH=$PWD

echo $BASEPATH

curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -

sudo apt-get update
sudo apt-get install -y nodejs build-essential mongodb nginx git fcgiwrap libkrb5-dev
sudo npm install -g pm2

sudo rm -f /etc/nginx/sites-enabled/*

sudo cp $BASEPATH/nginx/whisper /etc/nginx/sites-available/whisper
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

cp -R $BASEPATH/initialGit-JavaScript $BASEPATH/git-master

cd $BASEPATH/git-master
git init
git remote add origin http://localhost/git/whisper.git
git add --all
git commit -m "initial commit"
git push -u origin master

sudo ln -s $BASEPATH/git-hooks/update /srv/git/whisper.git/hooks

cd $BASEPATH
npm install
sudo pm2 start npm -n whisper -- start
sudo pm2 save
sudo pm2 startup systemd

wget --tries 10 --retry-connrefused --post-data '{"number": 0}' --header 'Content-Type:application/json' -qO- http://localhost:3000/round
