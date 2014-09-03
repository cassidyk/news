#!/bin/bash
## usage:   ./index.sh <int>
## example: ./index.sh 3
if [[ $# -ne 1 ]]; then
  index=0
else
  index=$1
fi

base="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
files="$base/strings"

ls -1 $files | grep -v files.sl > $files/files.sl
count=$(cat $files/files.sl | wc -l | tr -d ' ')
# valid if $index can generate a file
if [ $index -ge $count ]; then
  echo "$index is invalid."
  exit 1
fi

if [ $index -eq 0 ]; then
  # root file
  cat $files/0
else
  # lookup $index value
  index=$(( $index + 1 ))
  index=`head -$index $files/files.sl | tail -1`

  if [[ -d $files/$index ]]; then
    cd $files/$index
    ls -1 $files/$index | grep -v files.sl | sort -g > files.sl

    # if file -> cat
    # if dir -> cat ./dir/b_i
    # a_i is from ./../0
    while read line
    do

      if [[ -d $files/$index/$line ]]; then
        cd $files/$index/$line
          cat $files/$index/$line/b_i
        cd ..
      elif [[ -f $files/$index/$line ]]; then
        cat $files/$index/$line
      else
        echo "$line is not valid"
        exit 1
      fi

    done < $files/$index/files.sl
  fi
fi
