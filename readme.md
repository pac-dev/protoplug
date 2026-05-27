protoplug
=========
Create audio plugins on-the-fly with LuaJIT.

Protoplug is a plugin that lets you load and edit Lua scripts as audio effects and instruments. Scripts can process audio and MIDI, draw their own interface, and use external libraries. It turns a DAW into a live coding environment for audio.

This fork modernizes Protoplug as version 1.5.1.

<img width="1440" height="900" alt="Image" src="https://github.com/user-attachments/assets/46a141c5-3a1c-4b17-af0f-b4fd829b39ef" />

---

<img width="1440" height="900" alt="image" src="https://github.com/user-attachments/assets/04e2acee-8ba1-44c8-84fc-f10264591303" />

Link for supporting the Re-Animator Project
-------------------------------------------
This is the first of many plugins to be revived under the Nebula Audio Re-Animator Project, you can support the project by donating via the following link:
https://subhankar42.gumroad.com/l/xdmspy

Supported plugin formats
------------------------
- macOS: universal AUv2, VST3, and CLAP for `arm64` and `x86_64`
- Windows: 64-bit VST3 and CLAP
- Linux: 64-bit VST3, CLAP, and LV2

Audio layouts up to 64 channels are supported where the host and plugin format
allow them. Existing stereo scripts continue to work, while multi-channel
scripts can use `plugin.numChannels`, `plugin.numInputChannels`,
`plugin.numOutputChannels`, or the `multiIO` helper.

LV2 is provided on Linux only. Protoplug is designed around one shared
`ProtoplugFiles` folder used by both the FX and Gen plugins. On Linux,
Protoplug already looks for that folder in `/usr/share/ProtoplugFiles`, a
standard system-wide location for shared application data, so VST3, CLAP, and
LV2 can all use the same installed resources. On macOS and Windows, Protoplug's
resource lookup is based around the plugin location instead of a single
system-wide LV2 resource path. Since LV2 bundles are expected to be
self-contained, supporting LV2 there would either require duplicating
`ProtoplugFiles` into separate FX and Gen bundles or adding a new platform
installer/resource-location convention just for LV2. The macOS and Windows
builds therefore focus on AUv2, VST3, and CLAP.

macOS keyboard shortcuts
------------------------
On macOS, DAWs may reserve command-key shortcuts for the host application while
a plugin editor is open. This is a platform and host safety behavior intended
to prevent plugin windows from accidentally triggering project-level DAW actions.
As a result, editor shortcuts such as Cmd+A, Cmd+C, Cmd+X, and Cmd+V may not
work in Protoplug when it is hosted inside a DAW on macOS, even though the same
shortcuts can work on Windows and Linux. Mouse selection and context-menu
editing remain available.

Building from source
--------------------
The modern build uses CMake and JUCE 8. CMake fetches JUCE and clap-juce-extensions automatically unless you set `PROTOPLUG_JUCE_DIR` or `PROTOPLUG_CLAP_JUCE_EXTENSIONS_DIR`.

macOS:
```sh
scripts/build-macos.sh
```

Linux:
```sh
sudo apt-get install -y cmake ninja-build pkg-config build-essential libasound2-dev libcurl4-openssl-dev libfreetype-dev libgl1-mesa-dev libgtk-3-dev libjack-jackd2-dev libwebkit2gtk-4.1-dev libx11-dev libxcursor-dev libxext-dev libxinerama-dev libxrandr-dev libxrender-dev
scripts/build-linux.sh
```

Windows, from a Developer PowerShell:
```powershell
scripts/build-windows.ps1
```

Each script builds Release plugins and creates a zip in `dist/` containing the plugin artifacts, `ProtoplugFiles`, this README, and the license.

Release Notes
-------------
See `RELEASE_NOTES.md` and `CHANGELOG.md` for version-specific changes.

Runtime libraries
-----------------
`ProtoplugFiles/lib` contains the LuaJIT and FFTW runtime libraries used by Protoplug and the bundled FFT examples.

- macOS uses universal `arm64;x86_64` Mach-O libraries: `libluajit-5.1.dylib` and `libfftw3.3.dylib`
- Linux uses x86_64 ELF libraries: `libluajit-5.1.so` and `libfftw3.so.3`
- Windows uses x86_64 DLLs: `lua51.dll` and `libfftw3-3.dll`

The macOS runtime libraries can be rebuilt with `scripts/build-macos-runtime-libs.sh`.

Manual CMake build
------------------
```sh
cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Release
cmake --build build --config Release --target protoplug_fx_All protoplug_gen_All protoplug_fx_CLAP protoplug_gen_CLAP
```

On macOS, the default CMake configuration builds universal `arm64;x86_64` binaries with deployment target `10.13`.

License
-------
Protoplug is MIT-licensed. See `license.txt`.

---

**Reporting Issues:**
For reporting any issues create an issue on the Github repository, and while creating the issue do mention your email ID in the issue. The issues of paid customers will be solved on priority basis (Minimum payment of $10). Free customers are expected to workout any issues on their own, no support will be provided to them.
