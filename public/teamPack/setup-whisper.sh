#!/bin/bash
if [ $# -ne 1 ]
then
  echo "Proper Usage:"
  echo "setup [TeamName]"
  exit
fi

git clone "http://$CODE_WHISPER_HOST/git/whisper.git" $1
cd $1
git checkout -b $1
git push -u origin $1

chmod 777 reconnect.sh

npm install
echo "All Done!"
