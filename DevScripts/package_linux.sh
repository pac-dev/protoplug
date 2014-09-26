#!/bin/bash

VERSION=`cat resources/version.txt`
ARCH=`uname -m`
PACKAGELIBS="libluajit-5.1.so libfftw3.so.3"

cd ../ProtoplugFiles/lib/

echo "Packaging libs..."
for PLIB in $PACKAGELIBS; do
	if [ ! -f $PLIB ]; then
		PLIBPATH=`strings -n5 /etc/ld.so.cache | grep "^/.*$PLIB$"`
		if [ -z "$PLIBPATH" ]; then
			echo -ne "\t FAILED: $PLIB not found for packaging\n"
			exit 1
		fi
		cp $PLIBPATH .
	fi
done

cd ../../Bin/linux
DST=../packaged/protoplug-$VERSION-linux-$ARCH.tar.gz

echo "Creating archive..."
tar -pczf $DST "Lua Protoplug Fx.so" "Lua Protoplug Gen.so" ../../ProtoplugFiles

echo "Packaging successful."