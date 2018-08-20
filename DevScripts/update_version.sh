#!/bin/bash

# Updates the version in source files, projects, etc.
# example usage:
# 	export JUCER_PATH="~/JUCE/Projucer"
# 	printf "6.66.0" > resources/version.txt
# 	./update_version.sh

set -e

VERSION=`cat resources/version.txt`

echo "Setting protoplug version $VERSION"

cd ../Builds
echo "Updating jucer files..."
# not your mother's xml parser
perl -0777 -pi -e 's/(<JUCERPROJECT[\S\s]*?version=)".*?"/\1"'"$VERSION"'"/g' fx/protoplug_fx.jucer
perl -0777 -pi -e 's/(<JUCERPROJECT[\S\s]*?version=)".*?"/\1"'"$VERSION"'"/g' gen/protoplug_gen.jucer

echo "Generating projects and makefiles..."
$JUCER_PATH --resave fx/protoplug_fx.jucer
$JUCER_PATH --resave gen/protoplug_gen.jucer

cd ../ProtoplugFiles
echo "Updating default scripts..."
perl -i -pe 's/\(version .*?\)/\(version '"$VERSION"'\)/g' effects/default.lua
perl -i -pe 's/\(version .*?\)/\(version '"$VERSION"'\)/g' generators/default.lua

echo "Version successfully updated."
