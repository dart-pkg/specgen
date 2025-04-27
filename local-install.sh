#! /usr/bin/bash
set -uvx
set -e
cwd=`pwd`

#pubspec
my-dart bin/main.dart

dart format .

./do-analyze.sh
./do-test.sh

cd bin
dart compile exe main.dart
cp -p main.exe ~/cmd/specgen.exe
