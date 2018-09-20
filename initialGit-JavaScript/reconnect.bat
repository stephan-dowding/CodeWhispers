set branch=
for /f "delims=" %%a in ('git symbolic-ref --short HEAD') do @set branch=%%a

git fetch
git reset --hard origin/%branch%
git clean -df

npm install
