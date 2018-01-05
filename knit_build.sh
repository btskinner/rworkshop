#!/bin/sh

# arguments
postdir=$1
scriptdir=$2
suf=$3

# knit
./knit.sh $postdir $scriptdir

# build
./build.sh $suf
