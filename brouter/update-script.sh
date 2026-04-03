#!/bin/bash

if [ -d ./segments4 ] && [ -f ./segments4/W180_S85.rd5 ]; then
  exit 0
fi

wget https://brouter.de/brouter/segments4 -q -O - | grep -Po '(?<=")(\w+\d+_\w+\d+.rd5)' | sed 's/^/https:\/\/brouter.de\/brouter\/segments4\//' > linksfinal.txt
mkdir tmp
cd tmp
wget -i ../linksfinal.txt
cd ..
rm -rf segments4
mv tmp segments4
rm linksfinal.txt