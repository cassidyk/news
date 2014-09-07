lowercase() {
  [ "$1" -lt 26 ] || return 1
  index=$(( $1 + 97 ))
  printf "\\$(printf '%03o' "$index")"
}

UPPERCASE() {
  [ "$1" -lt 26 ] || return 1
  index=$(( $1 + 65 ))
  printf "\\$(printf '%03o' "$index")"
}

