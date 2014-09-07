#!/bin/bash

# eval $cd $dir and make if DNE
cd='eval "if [[ ! -d $home/$dir ]]; then mkdir -p $home/$dir; fi; cd $home/$dir"'

## todo: string generator for eval. <() -> eman$

base="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
home=$1
eval $cd

# build diff from root
ls -1 | grep -v files.sl > files.sl
root=`head -1 $home/files.sl`

wc=$(cat $home/files.sl | wc -l | tr -d ' ')
if [[ $wc -lt 2 ]]; then exit 1; fi # nothing to compare

# for each other file, compare to root file
for index in `seq 2 $wc`
do
  leaf=`head -$index $home/files.sl | tail -1`

  ## todo: handle files that don't line up
  ## short files cut off, long files loop :last line

  signal=0
  dir=$leaf # relative path from $1
  eval $cd

  for line in `seq 1 $(cat $home/$leaf/a | wc -l | tr -d ' ')`
  do
    root_i=`head -$line $home/$root | tail -1`
    leaf_i=`head -$line $home/$leaf/a | tail -1`

    if [[ $root_i == $leaf_i ]]; then
      echo $root_i >> $signal
    else
      signal=$(( $line + 1 ))
      dir=$leaf/$line
      eval $cd

      echo $root_i > a_root
      echo $leaf_i > b_leaf
    fi
  done
done

dir=$home
home=$base
base=$dir
dir=''
eval $cd

./number.sh $base/0