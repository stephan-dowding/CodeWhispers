#!/bin/bash
if [ $# -ne 1 ]
then
  echo "Proper Usage:"
  echo "setup [TeamName]"
  exit
fi

CODEWHISPERS_HOST="codewhispers.org"

git clone "http://${CODEWHISPERS_HOST}/git/whisper.git" $1
cd $1

echo "export default '${CODEWHISPERS_HOST}'" > host.js

git checkout -b $1
git push -u origin $1

npm install
echo "All Done!"
