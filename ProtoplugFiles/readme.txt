ProtoplugFiles directory

This directory should be placed in the same location as the plugins, like this :

MyPluginsDir
|-- Lua Protoplug Fx.dll
|-- Lua Protoplug Gen.dll
+-- ProtoplugFiles
     |-- doc
     |-- effects
     |-- generators
   [...]

It's the default location for files that will be accessed at runtime by protoplug. If you wish to place some or all of it in another location, you can create symbolic links. Subdirectories in "effects", "generators", and "themes" create corresponding submenus. 

The "lib" folder is protoplug's first search path for the LuaJIT shared library, and for the script.ffiLoad function. 
