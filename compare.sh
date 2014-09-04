#!/bin/bash

chr() {
  [ "$1" -lt 256 ] || return 1
  printf "\\$(printf '%03o' "$1")"
}
int() {
  [ -n "$1" ] || return 1
  index=`printf '%d\n' "'$1"`
  echo $(( $index-65 ))
}

base="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
string="$base/strings"
files="$base/files"

rm -rf $string/*

# build 0 as root diff
ls -1 $files | grep .txt > $files/files.sl
A=`head -1 $files/files.sl | tail -1`
cat $files/$A > $string/0
echo '' >> $string/0

# for each other file, compare to root file
for index in `seq 2 $(cat $files/files.sl | wc -l | tr -d ' ')`
do
  B=`head -$index $files/files.sl | tail -1`
  #handle non equal length here

  signal=0
  index=$( chr $(( $index + 64 )) )
  base="$string/$index"
  mkdir $base

  for line in `seq 0 $(cat $files/$A | wc -l | tr -d ' ')`
  do
    a_i=`head -$(($line + 1)) $files/$A | tail -1`
    b_i=`head -$(($line + 1)) $files/$B | tail -1`

    if [[ $a_i == $b_i ]]; then
      echo $a_i >> $base/$signal
    else
      signal=$(( $line + 1 ))
      mkdir $base/$line
      echo $a_i > $base/$line/a_i
      echo $b_i > $base/$line/b_i
    fi
  done
done
