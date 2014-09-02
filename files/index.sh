#!/bin/bash
## usage:   ./index <int>
## example: ./index 3
chr() {
  [ "$1" -lt 256 ] || return 1
  printf "\\$(printf '%03o' "$1")"
}


dir='/Users/cassidyk/wheel/hackernews'
files="$dir/strings"

ls -1F $files | grep -v files.sl > $files/files.sl

count=1

while read line
do
  if [[ -d $files/$line ]]; then
    cd $files/$line
    i=`ls -1 | wc -l | tr -d ' '`
    if [[ $i -gt $count ]]; then
      count=$i
    fi
    cd ..
  fi
done < $files/files.sl


if [[ $# -ne 1 ]]; then
  index=0
else
  index=$1
fi

if [[ $index -lt $count ]]; then
  index=$( chr $(( $index + 97 )) )
else
  echo "$index is not valid"
  exit 1
fi


while read line
do
  if [[ -d $files/$line ]]; then
    cd $files/$line
      index+='_i'
      cat $index
    cd ..
  elif [[ -f $files/$line ]]; then
    cat $files/$line
  else
    echo "$line is not valid"
    exit 1
  fi
done < $files/files.sl













