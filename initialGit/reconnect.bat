set branch=
for /f "delims=" %%a in ('java -classpath branchFinder/org.eclipse.jgit-2.3.1.201302201838-r.jar:branchFinder/ branchFinder.Finder') do @set branch=%%a

git pull
git reset --hard origin/%branch%
