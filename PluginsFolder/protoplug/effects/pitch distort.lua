--[[
name: Pitch Distort
description: >
  graphical pitch distortion, 
  shifts each frequency band by a different factor
author: osar.fr
--]]

require "include/protoplug"
require "include/Pickle"

stereoFx.init()

fftlib = script.ffiLoad("libfftw3.so.3", "libfftw3-3")


ffi.cdef[[
typedef double fftw_complex[2];
void *fftw_plan_dft_r2c_1d(int n, double *in, fftw_complex *out, unsigned int flags);
void *fftw_plan_dft_c2r_1d(int n, fftw_complex *in, double *out, unsigned int flags);
void fftw_execute(void *plan);
]]

-- settings
local fftSize = 1024	-- 1024 seems good
local steps = 8			-- 4=low-fi, 16=high cpu
local xPixels = 400
local yPixels = 300

-- useful constants
local lineMax = fftSize
local rescale = 0.5/(fftSize*steps)
local cplxSize = math.floor(fftSize/2+1)
local stepSize = fftSize/steps
local expct = 2*math.pi*stepSize/fftSize;

-- global buffers
local graph = ffi.new ("double[?]", cplxSize)
for i = 0,cplxSize-1 do graph[i] = 0.25 end
local dbuf = ffi.new("double[?]", fftSize)
local spectrum = ffi.new("fftw_complex[?]", cplxSize)
local r2c = fftlib.fftw_plan_dft_r2c_1d(fftSize, dbuf, spectrum, 64)
local c2r = fftlib.fftw_plan_dft_c2r_1d(fftSize, spectrum, dbuf, 64)
local anaMagn = ffi.new("double[?]", cplxSize)
local anaFreq = ffi.new("double[?]", cplxSize)
local synMagn = ffi.new("double[?]", cplxSize)
local synFreq = ffi.new("double[?]", cplxSize)
local hw  = ffi.new("double[?]", fftSize) -- Hann window
for i = 0,fftSize-1 do
	hw[i] = (1 - math.cos(2*math.pi*i/(fftSize-1)))*rescale
end

local function ApplyWindow (samples)
	for i = 0,fftSize-1 do
		samples[i] = samples[i] * hw[i]
	end
end

-- channel buffers
function stereoFx.Channel:init()
	self.inbuf = ffi.new("double[?]", lineMax)
	self.outbuf = ffi.new("double[?]", lineMax)
	self.bufi = 0
	self.inphase = ffi.new("double[?]", cplxSize)
	self.outphase = ffi.new("double[?]", cplxSize)
end

-- filter the "spectrum" global given a channel's phases
local function ApplyFilter (inphase, outphase)
	-- setup
	for i=0,cplxSize-1 do
		synMagn[i] = 0
		synFreq[i] = 0
	end
	-- analysis
	for i=0,cplxSize-1 do
		local real = spectrum[i][0]
		local imag = spectrum[i][1]
		local magn = 2*math.sqrt(real*real+imag*imag)
		local phase = math.atan2(imag, real)
		local x = phase - inphase[i]
		inphase[i] = phase
		x = x - i*expct
		x = (x+math.pi)%(math.pi*2)-math.pi
		x = steps*x/(2*math.pi)
		x = i + x
		anaMagn[i] = magn
		anaFreq[i] = x
	end
	-- processing
	for i=0,cplxSize-1 do
		local shift = graph[i]*2+0.5
		local i2 = math.floor(i*shift)
		if i2<cplxSize and i2>0 then
				synMagn[i2] = anaMagn[i] + synMagn[i2]
				synFreq[i2] = anaFreq[i] * shift
		end
	end
	-- resynthesis
	for i=0,cplxSize-1 do
		local magn = synMagn[i]
		x = synFreq[i]
		x = x - i
		x = 2*math.pi*x/steps
		x = x + i*expct
		outphase[i] = outphase[i] + x
		local phase = outphase[i]
		spectrum[i][0] = magn * math.cos(phase)
		spectrum[i][1] = magn * math.sin(phase)
	end
end

function wrap (i)
	return (i>lineMax-1) and i-lineMax or i
end

function stereoFx.Channel:processBlock(s, smax)
	for i = 0,smax do
		self.inbuf[self.bufi] = s[i]
		s[i] = self.outbuf[self.bufi]
		self.outbuf[self.bufi] = 0
		if self.bufi%stepSize==0 then
			for j=0,fftSize-1 do
				dbuf[j] = self.inbuf[wrap(self.bufi+j)]
			end
			-- revive cdata (inexplicably required, todo-narrow down the cause):
			tostring(dbuf); tostring(spectrum)
			fftlib.fftw_execute(r2c)
			ApplyFilter (self.inphase, self.outphase)
			fftlib.fftw_execute(c2r)
			ApplyWindow(dbuf)
			for j=0,fftSize-1 do
				self.outbuf[wrap(self.bufi+j)] =
				 self.outbuf[wrap(self.bufi+j)] + dbuf[j]
			end
		end
		self.bufi = wrap(self.bufi+1)
	end
end


--			Graphics		 --
local Freqgraph = require "include/pac/freqgraph"
local J = require "include/protojuce"

local fg = Freqgraph {
	title = "Pitch distortion";
	data = graph;
	dataSize = cplxSize;
	yAxis = {
		name = "shift (%)";
		values = {
			[0] = "50";
			[0.25] = "100";
			[0.5] = "150";
			[1] = "250";
		}
	}
}

function gui.paint(g)
	g:fillAll()
	fg:paint(g)
end


--			Save & load		  --
local header = "pac pitch distort 1"

function script.loadData(data)
	-- check data begins with our header
	if string.sub(data, 1, string.len(header)) ~= header then return end
	data = unpickle(string.sub(data, string.len(header)+1, -1))
	-- check string was turned into a table without errors
	if data==nil then return end
	for i=0,cplxSize-1 do
		if data[i] ~= nil then
			graph[i] = data[i]
		end
	end
end

function script.saveData()
	local picktable = {}
	for i=0,cplxSize-1 do
		picktable[i] = graph[i]
	end
	return header..pickle(picktable)
end