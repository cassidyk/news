#!/bin/bash

# eval $cd $dir and make if DNE
cd='eval "if [[ ! -d $home/$dir ]]; then mkdir -p $home/$dir; fi; cd $home/$dir"'

## todo: string generator for eval. <() -> eman$

home=$1
eval $cd

# build diff from root
ls -1 | grep -v files.sl > files.sl
root=`head -1 $home/files.sl`

wc=$(cat $home/files.sl | wc -l | tr -d ' ')
if [[ $wc -lt 2 ]]; then exit 1; fi # nothing to compare

# for each other file, compare to root file
for index in `seq 2 $(cat $home/files.sl | wc -l | tr -d ' ')`
do
  leaf=`head -$index $home/files.sl | tail -1`

  ## todo: handle files that don't line up


  signal=0
  dir=$leaf # relative path from $1
  eval $cd

  for line in `seq 1 $(cat $home/$dir/0 | wc -l | tr -d ' ')`
  do
    root_i=`head -$line $home/$root | tail -1`
    leaf_i=`head -$line $home/$leaf/0 | tail -1`

    if [[ $root_i == $leaf_i ]]; then
      echo $root_i >> $signal
    else
      signal=$line
      dir=$leaf/$line
      eval $cd

      echo $root_i > 0_root
      echo $leaf_i > 0_leaf
    fi
  done
done