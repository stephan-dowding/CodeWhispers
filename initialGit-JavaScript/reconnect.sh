#!/bin/bash
branch=$(git symbolic-ref --short HEAD)

git fetch
git reset --hard origin/$branch
git clean -df

npm install
