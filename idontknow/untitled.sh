base="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
dir='output'

# eval $cd $dir and make if DNE
cd='eval "if [[ ! -d $home/$dir ]]; then mkdir -p $home/$dir; fi; cd $home/$dir"'
home=$base

# eval $lower $index in ruby
lower='eval $a1; eval $b1'
a1='b1="ruby <(echo puts $(( $index + 95 )).chr)"'

## building strings that entangle == building a string that evals on read
#ruby='eval ruby <(echo $cmd)'
#cmd='cmd="($signal) ? "$file" : '0'"'
#signal=0
#file=test
#eval $cmd
#eval $ruby

ls -1 | grep .txt > files.sl
root=`head -1 $home/files.sl`

wc=$(cat $home/files.sl | wc -l | tr -d ' ')
if [[ $wc -lt 2 ]]; then exit 1; fi # nothing to compare

mkdir $dir
cd $dir

for index in `seq 2 $wc`
do
  file=`head -$index $home/files.sl | tail -1`
  wc=$(cat $home/$file | wc -l | tr -d ' ')

  signal=0

  for i in `seq 1 $wc`
  do
    a=`head -$i $home/$root | tail -1`
    b=`head -$i $home/$file | tail -1`

    if [[ $a == $b ]]; then
      char=`eval $lower`
      echo $a >> $signal.$char
    else
      signal=$(( $i + 1 ))
      char=`eval $lower`
      echo $b > $i.$char
    fi
  done
done

mkdir $dir
cd $dir

ls -1 .. | grep a | grep -v a_list.sl | sort -g > a_list.sl
ls -1 .. | grep b | grep -v b_list.sl | sort -g > b_list.sl

a_count=$(cat a_list.sl | wc -l | tr -d ' ')
b_count=$(cat b_list.sl | wc -l | tr -d ' ')

a=`head -$a_count $home/$dir/$dir/a_list.sl | tail -1 | sed 's/.a$//'`
b=`head -$b_count $home/$dir/$dir/b_list.sl | tail -1 | sed 's/.b$//'`

while [ "true" == "true" ]
do
  [ $a_count -gt 1 ] || exit 0
  [ $b_count -gt 1 ] || exit 0

  if [[ $a -lt $b ]]; then
    b_count=$(( $b_count - 1 )) && b=`head -$b_count $home/$dir/$dir/b_list.sl | tail -1 | sed 's/.b$//'`
  elif [[ $a -gt $b ]]; then
    a_count=$(( $a_count - 1 )) && a=`head -$a_count $home/$dir/$dir/a_list.sl | tail -1 | sed 's/.a$//'`
  else
    mkdir $a
    for word in `cat ../$a.a`;
    do
      echo $word >> $a/a
    done
    for word in `cat ../$b.b`;
    do
      echo $word >> $b/b
    done
    a_count=$(( $a_count - 1 )) && a=`head -$a_count $home/$dir/$dir/a_list.sl | tail -1 | sed 's/.a$//'`
    b_count=$(( $b_count - 1 )) && b=`head -$b_count $home/$dir/$dir/b_list.sl | tail -1 | sed 's/.b$//'`
  fi
done
