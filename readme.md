protoplug
=========
Create audio plugins on-the-fly with LuaJIT.

- **Official website**: http://www.osar.fr/protoplug
- **Downloads**: https://github.com/pac-dev/protoplug/releases
- **Forums**: http://forums.osar.fr

Protoplug is a VST/AU plugin that lets you load and edit Lua scripts as audio effects and instruments. The scripts can process audio and MIDI, display their own interface, and use external libraries. Transform any music software into a live coding environment! 

**Cross-platform :** builds for Windows, Linux, and macOS. This means that all protoplug scripts are compatible with these platforms and can be loaded into a huge amount of audio software (glory to [JUCE](http://juce.com/)) 

**Fast :** Use the speed of [LuaJIT](http://luajit.org/) to perform complex DSP tasks in realtime.

**Free and open source :** The source is MIT-licensed. Hack away.


Compiling from Source
---------------------
There are [prebuilt binaries](https://github.com/pac-dev/protoplug/releases), but building it from source is also simple:

**Mac and Windows :** 

You'll need Visual Studio 2017 (Windows) or a recent XCode (macOS). Projects files are in the `Builds` folder.

**Linux :** 

For example, on Ubuntu 16:

	sudo apt-get install libluajit-5.1-2 libfftw3-3 build-essential pkg-config libgtk-3-dev libfreetype6-dev libx11-dev libasound2-dev libxinerama-dev libxcursor-dev libcurl4-openssl-dev
	tar zxf protoplug-1.4.0.tar.gz
	cd protoplug-1.4.0/Builds/multi/Linux/
	make CONFIG=Release

Then, optionally run `sudo make install` or just copy the binaries from `protoplug-1.4.0/Bin/linux` to wherever you want them.