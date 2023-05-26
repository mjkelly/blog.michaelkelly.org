#!/bin/bash
hugo --minify --cleanDestinationDir -d ./public || exit 1
./scripts/git-revision-stamp.sh > ./public/revision.txt || exit 1
