set branch=
for /f "delims=" %%a in ('java -jar lib\branchFinder.jar') do @set branch=%%a

git pull
git reset --hard origin/%branch%
