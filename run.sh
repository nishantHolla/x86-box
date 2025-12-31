#!/bin/sh

CC="as"
LD="ld"
COMPILE_FLAGS="-g -32"
LINK_FLAGS="-m elf_i386"
BUILD_DIR="./build"

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

rm -f $BUILD_DIR/*.o *.out

mkdir -p $BUILD_DIR

for file in $1/*.s; do
  base=`basename -s .s $file`
  $CC $COMPILE_FLAGS $file -o $BUILD_DIR/$base.o
done

$LD $LINK_FLAGS $BUILD_DIR/*.o -o $1.out
./$1.out "${@:2}"
