#! /bin/bash
set -ex
HERE=$(dirname $0)
SOURCE=$(realpath $1)
TARGET=$(realpath -m $2)

cd $HERE
mkdir --parents "build"
rm --force build/*

## It seems that cross.fs does not support sources outsdide of current directory.
## Working around that for now.
SOURCE_FILE="build-$(basename $SOURCE)"
cp "$SOURCE" "./$SOURCE_FILE"

gforth cross.fs basewords.fs "$SOURCE_FILE"

mkdir --parents "$(dirname $TARGET)"
cp "./build/$(basename --suffix=.fs $SOURCE_FILE).hex" "$TARGET"
rm "$SOURCE_FILE"
