#!/bin/bash -e

BASEDIR=$(dirname $0)

#####################################################################
#
# Inserts a require at the top of a file that assumes the file is in
# a dist/ folder (1 parent below the location of the .pnp.cjs file)
#
# Note: This will overwrite the file in question!
#
# cmd <cwd> <file location relative to cwd>
#
#####################################################################

cwd=$1
file=$2

if [ -z $cwd ]; then
    echo "Must provide cwd argument!"
    exit 1
fi
if [ -z $file ]; then
    echo "Must provide file argument!"
    exit 1
fi

cd $cwd
echo "Testing"
firstLine=$(head -n 1 $file)
if [[ "$firstLine" != "\"use strict\";" ]]; then
  postfix=$(cat $file)
  printf "require(‘../.pnp.cjs’).setup();\n$postfix" > $file;
else
  postfix=$(tail -n +2 $file)
  printf "\"use strict\";\nrequire('../.pnp.cjs').setup();\n$postfix" > $file;
fi
