#!/bin/bash

## does not work. eval $cd is not rendering with assumed value for $home

# eval $cd $dir and make if DNE
cd='eval "if [[ ! -d $home/$dir ]]; then mkdir -p $home/$dir; fi; cd $home/$dir"'

# eval $string $index in ruby
cmd='loop do (i < 26) ? (print (i + 65).chr; break) : (print "_"; i=(i - 26)) end'
string='ruby <(echo "i=$index; $cmd")'

base="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
home=$1
eval $cd

ls -1 | grep -v 0 | grep -v files.sl > files.sl

wc=$(cat $home/files.sl | wc -l | tr -d ' ')
if [[ $wc -lt 2 ]]; then exit 1; fi # nothing to compare


while read letter
do
  cd $home/$letter

  ls -1 | grep -v files.sl > files.sl
  wc=$(cat $home/$letter/files.sl | wc -l | tr -d ' ')

  for index in `seq 2 $wc`
  do
    num=`head -$index $home/$letter/files.sl | tail -1`
    if [[ -d $home/$letter/$num ]]; then
      dir="$letter/$num"
      eval $cd

      # get the only line within files
        root=`head -1 a_root | tail -1`
        leaf=`head -1 b_leaf | tail -1`


    ## stopped refactoring ##

    # seperate words into lines in files root and leaf
    for word in $root;
    do
      echo $word >> root
    done
    for word in $leaf;
    do
      echo $word >> leaf
    done

    cat $home/$letter/$num/root | wc -l | tr -d ' ' > root.cw
    cat $home/$letter/$num/leaf | wc -l | tr -d ' ' > leaf.cw

    if [ `cat root.cw` -gt `cat leaf.cw` ]; then
      ## can replace with a signal representing inverse assignments or ordered
      count=`cat leaf.cw`
    else
      count=`cat root.cw`
    fi

    for index in `seq 1 $count`
    do
      A_i=`head -$index $home/$letter/$num/root | tail -1`
      B_i=`head -$index $home/$letter/$num/leaf | tail -1`

      # dedup or $
      if [[ $A_i == $B_i ]]; then
        echo $A_i >> 0
      else
        name=$(eval $string)
        echo "$name$" >> 0

        dir="$home/$letter/$num/$name"
        eval $cd

        echo $A_i >> a_i
        echo $B_i >> b_i
      fi
    done

    ## hack job
    # handles remaining output in files when root || leaf is longer then the other
    if [ `cat root.cw` -ne `cat leaf.cw` ]; then
      if [ `cat root.cw` -gt `cat leaf.cw` ]; then
        index=$(( $index + 1 ))
        count=`cat root.cw`
        for index in `seq $index $count`
        do
          name=$(eval $string)
          echo "$name$" >> 0

          dir="$home/$letter/$num/$name"
          eval $cd

          echo $A_i >> a_i
        done
      else
        count=`cat leaf.cw`
        for index in `seq $index $count`
        do
          name=$(eval $string)
          echo "$name$" >> 0

          dir="$home/$letter/$num/$name"
          eval $cd

          echo $B_i >> b_i
        done
      fi
    fi
  done
done < $home/files.sl



dir=$home
home=$base
base=$dir
dir=''
eval $cd
