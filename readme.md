protoplug
=========
Create audio plugins on-the-fly with LuaJIT.

The official website is [here](http://osar.fr/protoplug).

Protoplug is a VST/AU plugin that lets you load and edit Lua scripts as audio effects and instruments. The scripts can process audio and MIDI, display their own interface, and use external libraries. 

**Cross-platform :** builds for Windows, Mac OS X and Linux. This means that all protoplug scripts are compatible with these platforms and can be loaded into a huge amount of audio software (glory to [JUCE](http://juce.com/)) 

**Fast :** Use the speed of [LuaJIT] [1], and perform DSP tasks as efficiently as old school C implementations. 

**Free and open source :** Want a new feature? Add it yourself. The source is MIT-licensed.

  [1]: http://luajit.org/


Downloads
---------
Look in the Releases section for binaries for your platform. 


Installing - Making it Work
---------------------------
**Windows :**  Extract the release zip to your VST folder (eg. `C:\Program Files\Cubase\VSTPlugins`). You can now load protoplug in your host. 

**Linux :** protoplug is also a native Linux VST (`.so`). There is no standard install location for Linux VSTs, but you can copy the whole thing to `/usr/lib/vst` for example. 

**OSX :** The OSX version is a polyglot AU/VST plugin. It's not available as 64-bit, as [LuaJIT doesn't support it properly] [2]. However, any advanced 64-bit host should still load the plugin in bridged mode. Otherwise, try launching the host in 32-bit mode.

  [2]: http://luajit.org/install.html#embed


Compiling from Source
---------------------
The source is C++ and only requires system headers. In the source's `MetaBuilds` folder, there are various kinds of project files allowing you to build the effect and instrument in one shot. (The [Introjucer] [3] is used to create the basic projects and makefiles.) 

  [3]: http://www.juce.com/documentation/introjucer
  
After compiling, you'll also need the [LuaJIT] [1] shared library installed on your system or in the `protoplug/lib` folder. The same goes for [FFTW] [4] if you want to load scripts that use that library. 

  [4]: http://fftw.org/

**Linux :** The easiest is to grab the binaries above, but you can also compile it : 

	tar zxf protoplug-1.0.0.tar.gz
	cd protoplug-1.0.0/MetaBuilds/Linux
	make

You might get some missing includes. The required headers should be easy to obtain, for example on Debian 7 :

	sudo apt-get install libfreetype6-dev libx11-dev \
	 libasound2-dev libxinerama-dev libxcursor-dev
