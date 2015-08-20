@echo off

if "%1" == "" goto bad

if "%2" == "" goto doit

:bad
  echo Proper Usage:
  echo run-app.bat [CodeWhisperIPAddress]
  goto :eof


:doit
  echo "clean output dir"
  RD /S /Q out
  MD out

  rem "compile"
  echo "Compiling classes to out folder"
  javac -classpath lib/"*" -d out src/*

  rem "run"
  echo "Running the app using question server %1"
  java -classpath lib/"*";out Whisper %1
