#!/bin/bash

list=$(for i in $(cat $1 | sort -nu); do
echo -e "$i:\t$(grep -x $i $1 | wc -l)"
done)

echo "$list"
