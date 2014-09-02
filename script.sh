#!/bin/bash

dir='/Users/cassidyk/wheel/hackernews'
string="$dir/strings"
files="$dir/files"

rm -rf $string/*
curl https://news.ycombinator.com/ > $files/`date +%s`.txt

ls -1F $files | grep .txt > $files/files.sl
A=`head -1 $files/files.sl | tail -1`
B=`head -2 $files/files.sl | tail -1`

signal=0

# handle non equal length here

for line in `seq 0 $(cat $files/$A | wc -l | tr -d ' ')`
do
  a_i=`head -$(($line + 1)) $files/$A | tail -1`
  b_i=`head -$(($line + 1)) $files/$B | tail -1`

  if [[ $a_i == $b_i ]]; then
    echo $a_i >> $string/$signal
  else
    signal=$(( $line + 1 ))
    mkdir $string/$line
    echo $a_i > $string/$line/a_i
    echo $b_i > $string/$line/b_i
  fi
done