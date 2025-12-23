#!/bin/sh

if [[ "$1" == "clean" ]] ; then
  rm -f *.o *.out
  exit
fi

rm -f *.o *.out

for file in $1/*.s; do
  base=`basename -s .s $file`
  as $file -o $base.o
done

ld *.o -o $1.out
./$1.out
