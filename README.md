Build Status: [![Build Status](https://snap-ci.com/stephan-dowding/CodeWhispers/branch/master/build_image)](https://snap-ci.com/stephan-dowding/CodeWhispers/branch/master)

At some point explain how to set up the server etc...


The Git magic:

Each team will have it's own branch.. Let's say they are one and two.

set them up on the machine by,

git clone ...
git checkout -b one
git push -u origin one

[[Same for two]]

From our master repo..

# delete local branches
git checkout master
git branch -d one
git branch -d two

#get latest
git pull

#get all branches
git checkout one
git checkout two

#don't move things from under your feet!
git checkout master

#delete remote branches
git push origin :one
git push origin :two

#rename local branches (I'm not using "temp" as I don't want to force myself to cycle)
git branch -m one t--one
git branch -m two t--two
git branch -m t--one two
git branch -m t--two one

#push and reconnect
git checkout one
git push -u origin one

git checkout two
git push -u origin two

git checkout master


Back on the user machine...

git fetch
git reset --hard origin/one

[[same for two]]


SETUP for git repo
In bare host repo add magic "git-daemon-export-ok" file
run git daemon (we don't care about authenticated checkins so this is ok)
  git daemon --enable=receive-pack --interpolated-path=[path to repo]
git clone git://[host]/ cloneName    <-- to clone
