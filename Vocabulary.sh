#!/bin/bash

for f in $@; do
   awk '{ for(i=3;i<=NF;++i) print $i; }' $f | sort -u > ${f}.vocab
done
