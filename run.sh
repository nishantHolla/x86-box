#!/bin/sh

if [ "$#" -ne 1 ]; then
  echo -e "Usage: ./run.sh <folder_name|\"clean\">"
  exit 1
fi

if [[ "$1" == "clean" ]] ; then
  rm -f *.o *.out
  exit 1
fi

if [[ ! -d "$1" ]]; then
  echo -e "Error: Could not find $1 folder"
  exit 1
fi

rm -f *.o *.out

AS_FLAGS="-g -32"
LD_FLAGS="-m elf_i386"

for file in $1/*.s; do
  base=`basename -s .s $file`
  as $AS_FLAGS $file -o $base.o
done

ld $LD_FLAGS *.o -o $1.out
./$1.out
