#!/bin/bash
VERSION=`cat resources/version.txt`
FOLDERLIST="../ProtoplugFiles
../Bin/mac/Release/Lua Protoplug Fx.vst
../Bin/mac/Release/Lua Protoplug Fx.component
../Bin/mac/Release/Lua Protoplug Gen.vst
../Bin/mac/Release/Lua Protoplug Gen.component"
TDMG_SRC="resources/protoplug_template.dmg"
TDMG_MOUNT="/Volumes/Lua Protoplug"
TDMG_TMP="/tmp/protoplug_temp.dmg"
TDMG_DST="../Bin/packaged/protoplug-$VERSION-osx.dmg"

PACKAGELIBDIR="$HOME/Documents/ProtoplugFiles/lib/"
PACKAGELIBS="libluajit-5.1.so libfftw3-3.so"

echo "Packaging libs..."
for PLIB in $PACKAGELIBS; do
	if [ ! -f $PACKAGELIBDIR$PLIB ]; then 
		echo -ne "\t FAILED: could not find $PACKAGELIBDIR$PLIB\n"
		exit 1
	fi
	cp $PACKAGELIBDIR$PLIB ../ProtoplugFiles/lib
done

if [ -e $TDMG_TMP ]; then
	umount "$TDMG_MOUNT" 2>/dev/null
	rm -f $TDMG_TMP
fi

echo "Unpack template to $TDMG_TMP"
if [ ! -e $TDMG_SRC.bz2 ]; then
	echo -ne "\t FAILED $TDMG_SRC.bz2 does not exit\n"
	exit 1
fi

bunzip2 $TDMG_SRC.bz2 -c > $TDMG_TMP	
if [ $? -ne 0 ]; then
	echo -ne "\t FAILED\n"
else
	echo -ne "\t DONE $TDMG_TMP\n"
fi
echo

echo "Mount $TDMG_TMP"
DEV=`hdiutil attach -readwrite -noverify -noautoopen $TDMG_TMP | tail -n 1 | grep "/dev/disk" | awk '{print $1}'`
if [ $? -ne 0 ]; then
	echo -ne "\t FAILED\n"
	exit 1
else
	echo -ne "\t DONE ($DEV)\n"
fi
echo

echo "Copy to template"
IFS=$'\n'
for f in $FOLDERLIST; do
	cp -r "$f" "$TDMG_MOUNT"
done
	
echo "Unmount"
umount "$TDMG_MOUNT"

if [ $? -ne 0 ]; then
	echo -ne "\t FAILED\n"
	exit 1
fi
echo

echo "Kill diskimage helpers"
PID=`lsof /tmp/protoplug_temp.dmg | tail -n 1 | awk '{print $2}'`
if [ $PID != "" ]; then
	kill -9 $PID
	echo -ne "\t DONE\n"
fi
echo

echo "Compact $TDMG_TMP to $TDMG_DST"
rm -f $TDMG_DST
hdiutil convert $TDMG_TMP -format UDBZ -o $TDMG_DST
if [ $? -ne 0 ]; then
	echo -ne "\t FAILED\n"
	exit 1
fi

echo "Packaging successful."
