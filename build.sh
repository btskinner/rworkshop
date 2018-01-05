#!/bin/sh

# arguments
sub=$1

# Script to quickly build site
jekyll build --config ./_config${sub}.yml --destination ./_site${sub}
