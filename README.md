Build Status: [![Build Status](https://snap-ci.com/stephan-dowding/CodeWhispers/branch/master/build_image)](https://snap-ci.com/stephan-dowding/CodeWhispers/branch/master)

# Setup the server
`vagrant up`

# Bootstrap script for ubuntu box
`setup-box.sh`

# Dashboard to project on big screen
`192.168.33.10/dashboard`

# Admin console to move the rounds
`192.168.33.10/control-panel`


# The Git magic:

Each team will have it's own branch.. Let's say they are `$one` and `$two`.

set them up on the machine by,
```sh
git clone ...
git checkout -b $one
git push -u origin $one

# Same for $two
```

## From our master repo:

```sh
# delete local branches
git checkout master
git branch -d $one
git branch -d $two

# get latest
git pull

# get all branches
git checkout $one
git checkout $two

# don't move things from under your feet!
git checkout master

# delete remote branches
git push origin ":${one}"
git push origin ":${two}"

# rename local branches (I'm not using "temp" as I don't want to force myself to cycle)
git branch -m $one "t--${one}"
git branch -m $two "t--${two}"
git branch -m "t--${one}" $two
git branch -m "t--${two}" $one

# push and reconnect
git checkout $one
git push -u origin $one

git checkout $two
git push -u origin $two

git checkout master
```

## Back on the user machine:

```sh
git fetch
git reset --hard origin/$one

# Same for $two
```

# SETUP for git repo
* In bare host repo add magic `git-daemon-export-ok` file
* run git daemon (we don't care about authenticated checkins so this is ok)

```sh
git daemon --enable=receive-pack --interpolated-path=$path_to_repo
git clone git://$host/ cloneName
```


# CodeWhispers meta development
* run `vagrant up` and make sure the round 0 is running at: `192.168.33.10`
* run tests with `./node_modules/.bin/mocha -u exports test/`
