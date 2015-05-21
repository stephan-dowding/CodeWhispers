@echo off

if "%1" == "" goto bad
if "%2" == "" goto bad

if "%3" == "" goto doit

:bad
  echo Proper Usage:
  echo setup [TeamName] [GitServer]
  goto :eof


:doit
  git clone %2 %1
  cd %1
  git checkout -b %1
  git push -u origin %1
  echo "All Done!"
