@echo off

if "%1" == "" goto bad

if "%2" == "" goto doit

:bad
  echo Proper Usage:
  echo setup [TeamName]
  goto :eof


:doit
  git clone "http://codewhispers.org/git/whisper.git" %1
  cd %1
  git checkout -b %1
  git push -u origin %1
  npm install
  echo "All Done!"
