#!/bin/bash

# if [ -d ./segments4 ] && [ -f ./segments4/W180_S85.rd5 ]; then
#   exit 0
# fi

mkdir tmp
wget -i ${PWD}/segments4/linksfinal.txt -P tmp
rm -rf segments4
mv tmp segments4