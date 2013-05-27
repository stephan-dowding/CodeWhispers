if %1 == "" GOTO :bad
if %2 == "" GOTO :bad
if %3 == "" GOTO :doit

:bad

  echo "Proper Usage:"
  echo "setup [TeamName] [GitServer]"
  GOTO :eof

:doit

git clone %2 %1
cd %1
git checkout -b %1
git push origin %1
git branch --set-upstream %1 origin/%1

echo "All Done!"
