branch=$(java -jar lib/branchFinder.jar)
git pull
git reset --hard origin/$branch
