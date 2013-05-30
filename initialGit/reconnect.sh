branch=$(java -classpath branchFinder/org.eclipse.jgit-2.3.1.201302201838-r.jar:branchFinder/ branchFinder.Finder)
git pull
git reset --hard origin/$branch
