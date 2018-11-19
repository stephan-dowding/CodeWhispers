#!/bin/sh

npm install
mkdir git-master
cp -R ./initialGit-JavaScript/. ./git-master
cd git-master
chmod 755 reconnect.sh
git init
git remote add origin http://git/repo.git
git add --all
git commit -m "initial commit"
git push -u origin master
cd ..
npm start
