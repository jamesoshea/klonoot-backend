#!/bin/bash

if [ -d ./segments4 ] && [ -f ./segments4/E10_N45.rd5 ]; then
  exit 0
fi

mkdir segments4
cd segments4
wget https://brouter.de/brouter/segments4/E10_N45.rd5
ls -a