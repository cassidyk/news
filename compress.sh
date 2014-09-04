#!/bin/bash
## usage:   ./compress.sh <char>
## example: ./compress.sh B
if [[ $# -ne 1 ]]; then
  letter='B'
else
  letter=$1
fi

chr() {
  [ "$1" -lt 256 ] || return 1
  printf "\\$(printf '%03o' "$1")"
}

#compress strings of \d*$ into A$ B$ C$ ...
# 1$, 2$, 3$ => A$ and \A contains `(3 1$) # counts and start

base="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
dir="$base/strings/$letter"

while read line
do
  if [[ -d $dir/$line ]]; then
    cd $dir/$line
      cat $dir/$line/0 | wc -l | tr -d ' ' > 0.cw

      cw=`cat 0.cw`
      for index in `seq 1 $cw`
      do
        A1=`head -$index $dir/$line/0 | tail -1`
        if [ "$index$" == $A1 ]; then # exif '700$' == "line from /0"$
          count=$(( $count + 1 ))     # exif => example if: "example" input assumed true.
                                      #            maps to: ln -s /dev/true
          if [[ $signal -eq 0 ]]; then
            start=$index
          fi
          signal=1
        else
          if [[ $signal -eq 1 ]]; then
            cd $dir/$line
            echo $start $count > "0.$start" # will echo "blank" line if $start && $count are unset
          fi
          count=0
          signal=0
        fi
      done
      #test if last line is $var
    cd .
  fi
done < $dir/files.sl
