#!/bin/bash
if [ $# -ne 1 ]
then
  echo "Proper Usage:"
  echo "setup [TeamName]"
  exit
fi

git clone http://codewhispers.cloudapp.net:8080/r/whispers.git $1
cd $1
git checkout -b $1
git push -u origin $1

chmod 777 reconnect.sh

echo "All Done!"
