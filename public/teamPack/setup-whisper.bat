@echo off

if "%1" == "" goto bad

if "%2" == "" goto doit

:bad
  echo Proper Usage:
  echo setup [TeamName]
  goto :eof


:doit
  git clone http://codewhispers.cloudapp.net:8080/r/whispers.git %1
  cd %1
  git checkout -b %1
  git push -u origin %1
  echo "All Done!"
