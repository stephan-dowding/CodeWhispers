@echo off

if "%1" == "" goto bad

if "%2" == "" goto doit

:bad
  echo Proper Usage:
  echo setup [TeamName]
  goto :eof


:doit
  git clone http://chinesewhisper.cloudapp.net/r/whispers.git %1
  cd %1
  git checkout -b %1
  git push -u origin %1
  echo "All Done!"
