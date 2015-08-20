#!/bin/sh
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 CODE WHISPER SERVER IP ADDRESS"
  exit 1
fi

#clean output dir
rm -r ./out
mkdir ./out

#compile
echo "Compiling classes to out folder"
javac -classpath ./lib/"*" -d out -sourcepath ./src ./src/*.java

#run
echo "Running the app using question server $1"
java -classpath ./lib/"*":./out Whisper $1
