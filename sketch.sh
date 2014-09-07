#ensure compress has been run on all folders
#may require existance file to signal

base="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
strings="$base/strings"

ls -1FR $strings | grep -v files.sl | sort -g > files.sl


while read line
do
  if [[ -d $dir/$line ]]; then
    cd $dir/$line
      # build a filesystem that contains only what it needs to generate
      # use the completed system to parse anime rss feed
      # ./sketch.sh $rss > fifo
      # head -1 < fifo # fetch rss feed 1 line at a time

      if #begins with '.' and ends with ':'
        #count number of '/'
        if # num == 1
          level='uppercase'
        if # num == 2
          level='number'
        if # num == 3
          level='lowercase' # or 0=0 :a series of tubes

        # act out assumed level

      fi
    cd .
  fi
done < $strings/files.sl