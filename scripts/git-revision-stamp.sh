#!/bin/bash

# Outputs a single line of info about the current git revision, relative to the
# current directory. I use this so I can be certain what revision a given
# website is running, in case I need to revert or fix forward.
rev=$(git rev-parse HEAD 2>/dev/null)
ret=$?
if [[ $ret -eq 0 ]]; then
  echo -n "${rev}"
else
  echo "NONE (not a git repository)"
  exit
fi
if [[ -n $(git status --short) ]]; then
  echo -n " (local modifications)"
fi
echo
