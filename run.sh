#!/bin/sh

if [ "$#" -lt 1 ]; then
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

CC="gcc"
CFLAGS="-m32 -g -c -fno-pie"
LDFLAGS="-m32 -nostartfiles -no-pie"

# Assemble all .s files
for file in "$1"/*.s; do
  base=$(basename "$file" .s)
  $CC $CFLAGS "$file" -o "$base.o"
done

# Link
$CC $LDFLAGS *.o -o "$1.out"

# Run
./"$1.out" "${@:2}"

