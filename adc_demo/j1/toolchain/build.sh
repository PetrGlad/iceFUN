#! /bin/bash
set -e
HERE=$(dirname $0)
SOURCE=$(realpath $1)
TARGET=$(realpath $2)

cd $HERE
mkdir --parents "build"
rm --force build/*
cp "$SOURCE" .
gforth cross.fs basewords.fs "$(basename $SOURCE)"
mkdir --parents "$(dirname $TARGET)"