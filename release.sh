#! /usr/bin/bash
set -uvx
set -e
cwd=`pwd`
version=$(pkgver)
comment=$1

echo $version

#pubspec "$version"
./bin/main.dart "$version"

dart format .

./do-analyze.sh
./do-test.sh

cat << EOS >> CHANGELOG.md

## $version

- $comment
EOS

dos2unix pubspec.yaml
dos2unix CHANGELOG.md

cd $cwd
tag="specgen-$version"
git add .
git commit -m"specgen: $comment"
git tag -a "$tag" -m"$tag"
git push origin "$tag"
git push origin HEAD:main
git remote -v

dart pub publish --force
