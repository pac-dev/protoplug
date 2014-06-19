-- protoplug.lua
-- basic globals for every protoplug script

-- luaJIT
ffi = require "ffi"
bit = require "bit"

-- load protoplug as a dynamic library using ffi
protolib = ffi.load(protoplug_path)

juce 		= require "include/protojuce"

midi 		= require "include/core/midi"
script 		= require "include/core/script"
plugin 		= require "include/core/plugin"
gui 		= require "include/core/gui"
polyGen 	= require "include/core/polygen"
stereoFx 	= require "include/core/stereofx"

