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
dir="$base/strings/$letter"
cd $dir
ls -1 $dir | grep -v files.sl | sort -g > files.sl

while read line
do
  if [[ -d $dir/$line ]]; then
    cd $dir/$line

    ## cleanup
    mv a_i ../i_a
    mv b_i ../i_b
    rm -rf *
    mv ../i_a ./a_i
    mv ../i_b ./b_i

    # get the only line within files a_i b_i
    a_i=`head -1 $dir/$line/a_i | tail -1`
    b_i=`head -1 $dir/$line/b_i | tail -1`

    # seperate words into lines in files a_j b_j
    for word in $a_i;
    do
      echo $word >> a_j
    done
    for word in $b_i;
    do
      echo $word >> b_j
    done

    cat $dir/$line/a_j | wc -l | tr -d ' ' > a_j.cw
    cat $dir/$line/b_j | wc -l | tr -d ' ' > b_j.cw

    if [ `cat a_j.cw` -gt `cat b_j.cw` ]; then
      ## can replace with a signal representing inverse assignments or ordered
      count=`cat b_j.cw`
    else
      count=`cat a_j.cw`
    fi

    for index in `seq 1 $count`
    do
      A_i=`head -$index $dir/$line/a_j | tail -1`
      B_i=`head -$index $dir/$line/b_j | tail -1`

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
    # handles remaining output in files when one of a_j b_j is longer then the other
    if [ `cat a_j.cw` -ne `cat b_j.cw` ]; then
      if [ `cat a_j.cw` -gt `cat b_j.cw` ]; then
        index=$(( $index + 1 ))
        count=`cat a_j.cw`
        for index in `seq $index $count`
        do
          echo "$index$" >> 0

          mkdir $index
          cd $index
            echo $A_i >> a_i
          cd ..
        done
      else
        count=`cat b_j.cw`
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
