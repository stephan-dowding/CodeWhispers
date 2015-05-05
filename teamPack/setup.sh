#!/bin/bash
if [ $# -ne 2 ]
then
  echo "Proper Usage:"
  echo "setup [TeamName] [GitServer]"
  exit
fi

git clone $2 $1
cd $1
git checkout -b $1
git push -u origin $1

chmod 777 reconnect.sh

echo "All Done!"
