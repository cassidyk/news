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
