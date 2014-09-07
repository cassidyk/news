#!/bin/bash

# Given /dir
  # which contains
    # a list
      # of files
        # to compare

#assume $1 -eq "/absolute/path" || "~/relative/path"
#assume $1 -eq nil -> ~
base="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
home=$base

if [[ -n "$1" ]]; then
  arg=$1
  test=`echo $arg | cut -c 1`

  if [[ $test == '~' ]]; then
    home=${arg/\~/$home}

  #assume $1[0] -ne / -> ~/$1
    #$1[0] -> $1.0 -> $1/0
  elif [[ $test != '/' ]]; then
    home=$home/$1
  else
    home=$arg
  fi
fi

# eval $cd $dir and make if DNE
cd='eval "if [[ ! -d $home/$dir ]]; then mkdir -p $home/$dir; fi; cd $home/$dir"'

# eval $UPPER $index in ruby
UPPER='eval $a; eval $b'
a='b="ruby <(echo puts $(( $index + 64 )).chr)"'


# build namespace aka a space for names
eval $cd
ls -1 | grep .txt > files.sl
root=`head -1 $home/files.sl`

wc=$(cat $home/files.sl | wc -l | tr -d ' ')
if [[ $wc -lt 2 ]]; then exit 1; fi # nothing to compare

dir='0'
eval $cd
cat $home/$root > 0

for index in `seq 2 $wc`
do
  file=`head -$index $home/files.sl | tail -1`
  dir="0/$(eval $UPPER)"
  eval $cd
    cat $home/$file > 0
  cd ..
done

dir=$home
home=$base
base=$dir
dir=''
eval $cd

./UPPERCASE.sh $base/0