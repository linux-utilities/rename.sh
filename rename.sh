#!/usr/bin/env bash

ACTION=
TYPE=
PATTERN=

_usage() {
  cat << EOL >&2
Usage: $0 <action> <type> <pattern>

Available actions:
  add   Adds the specified part to filenames
  del   Deletes the specified part from filenames

Available types:
  pre   Execute the <action> before the original filename
  post  Execute the <action> after the original filename

Pattern:
  Case-sensitive string to insert/remove

EOL
  exit 1
}

_rename() {
  if [ "$ACTION" = "add" ]; then
    if [ "$TYPE" = "pre" ]; then
      for file in $(ls); do
        mv "$file" "$PATTERN$file"
      done
    else
      for file in $(ls); do
        mv "$file" "$file$PATTERN"
      done
    fi
  else
    if [ "$TYPE" = "pre" ]; then
      for file in $(ls); do
        mv "$file" $(echo "$file" | sed "s/^$PATTERN//") &>/dev/null
      done
    else
      for file in $(ls); do
        mv "$file" $(echo "$file" | sed "s/$PATTERN$//") &>/dev/null
      done
    fi
  fi
}

for prm in "$@"; do
  if [ "$prm" = "add" ] || [ "$prm" = "del" ]; then
    ACTION="$prm"
  elif [ "$prm" = "pre" ] || [ "$prm" = "post" ]; then
    TYPE="$prm"
  else
    PATTERN="$prm"
  fi
done

if [ -z "$ACTION" ] || [ -z "$TYPE" ] || [ -z "$PATTERN" ] || [ "$#" != 3 ]; then
  _usage
else
  _rename
fi
