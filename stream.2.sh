#!/bin/bash
## usage:   ./stream.sh <char>
## example: ./stream.sh B
if [[ $# -ne 1 ]]; then
  letter='B'
else
  letter=$1
fi

chr() {
  [ "$1" -lt 256 ] || return 1
  printf "\\$(printf '%03o' "$1")"
}

# start in $letter dir
base="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
dir="$base/files/0/$letter"
cd $dir
ls -1 $dir | grep -v files.sl | sort -g > files.sl

while read line
do
  if [[ -d $dir/$line ]]; then
    cd $dir/$line

    # get the only line within files a_i b_i
    a_i=`head -1 $dir/$line/a_root | tail -1`
    b_i=`head -1 $dir/$line/b_leaf | tail -1`

    # seperate words into lines in files root and leaf
    for word in $a_i;
    do
      echo $word >> root
    done
    for word in $b_i;
    do
      echo $word >> leaf
    done

    cat $dir/$line/a_root | wc -l | tr -d ' ' > root.cw
    cat $dir/$line/b_leaf | wc -l | tr -d ' ' > leaf.cw

    if [ `cat root.cw` -gt `cat leaf.cw` ]; then
      ## can replace with a signal representing inverse assignments or ordered
      count=`cat leaf.cw`
    else
      count=`cat root.cw`
    fi

    for index in `seq 1 $count`
    do
      A_i=`head -$index $dir/$line/a_root | tail -1`
      B_i=`head -$index $dir/$line/b_leaf | tail -1`

      # dedup or $
      if [[ $A_i == $B_i ]]; then
        echo $A_i >> 0
      else
        echo "$index$" >> 0

        mkdir $index
        cd $index
          echo $A_i >> a_i
          echo $B_i >> b_i
        cd ..
      fi
    done

    ## hack job
    # handles remaining output in files when one of root and leaf is longer then the other
    if [ `cat root.cw` -ne `cat leaf.cw` ]; then
      if [ `cat root.cw` -gt `cat leaf.cw` ]; then
        index=$(( $index + 1 ))
        count=`cat root.cw`
        for index in `seq $index $count`
        do
          echo "$index$" >> 0

          mkdir $index
          cd $index
            echo $A_i >> a_i
          cd ..
        done
      else
        count=`cat leaf.cw`
        for index in `seq $index $count`
        do
          echo "$index$" >> 0

          mkdir $index
          cd $index
            echo $B_i >> b_i
          cd ..
        done
      fi
    fi
    cd .
  fi
done < $dir/files.sl
