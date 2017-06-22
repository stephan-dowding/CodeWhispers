#!/bin/sh -e

BASEPATH=$PWD

echo $BASEPATH

curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list

curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -

sudo apt-get update
sudo apt-get install -y nodejs build-essential mongodb nginx git fcgiwrap libkrb5-dev yarn
sudo npm install -g pm2 coffee-script

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

mkdir $BASEPATH/git-master
cp -R $BASEPATH/initialGit-Ruby/* $BASEPATH/git-master/

cd $BASEPATH/git-master
git init
git remote add origin http://localhost/git/whisper.git
git add --all
git commit -m "initial commit"
git push -u origin master

sudo ln -s $BASEPATH/git-hooks/update /srv/git/whisper.git/hooks

cd $BASEPATH
yarn install --production
sudo pm2 install coffeescript
sudo pm2 start app.coffee -n whisper
sudo pm2 startup systemd

wget --tries 10 --retry-connrefused --post-data '{"number": 0}' --header 'Content-Type:application/json' -qO- http://localhost:3000/round
