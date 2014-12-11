--[[
name: Pitch Shift - Bernsee Algo
description: "Simple" FFT pitch shifter after S.Bernsee's famous article. 
author: osar.fr
--]]

require "include/protoplug"

stereoFx.init()

fftlib = script.ffiLoad("libfftw3.so.3", "libfftw3-3")

-- params
local shift = 1			-- param=0.5 -> shift=1.0 (no shift)

-- settings
local fftSize = 1024	-- 1024 seems good
local steps = 8			-- 4=low-fi, 16=high cpu

-- useful constants
local lineMax = fftSize
local rescale = 1/(fftSize*steps)
local cplxSize = math.floor(fftSize/2+1)
local stepSize = fftSize/steps
local expct = 2*math.pi*stepSize/fftSize;

ffi.cdef[[
typedef double fftw_complex[2];
void *fftw_plan_dft_r2c_1d(int n, double *in, fftw_complex *out, unsigned int flags);
void *fftw_plan_dft_c2r_1d(int n, fftw_complex *in, double *out, unsigned int flags);
void fftw_execute(void *plan);
]]

-- global buffers
local dbuf = ffi.new("double[?]", fftSize)
local spectrum = ffi.new("fftw_complex[?]", cplxSize)
local anaMagn = ffi.new("double[?]", cplxSize)
local anaFreq = ffi.new("double[?]", cplxSize)
local synMagn = ffi.new("double[?]", cplxSize)
local synFreq = ffi.new("double[?]", cplxSize)
local hw  = ffi.new("double[?]", fftSize) -- Hann window
for i = 0,fftSize-1 do
	hw[i] = (1 - math.cos(2*math.pi*i/(fftSize-1)))*rescale
end

local function applyWindow (samples)
	for i = 0,fftSize-1 do
		samples[i] = samples[i] * hw[i]
	end
end

-- fftw plans
local r2c = fftlib.fftw_plan_dft_r2c_1d(fftSize, dbuf, spectrum, 64)
local c2r = fftlib.fftw_plan_dft_c2r_1d(fftSize, spectrum, dbuf, 64)

-- per-channel buffers
function stereoFx.Channel:init()
	self.inbuf = ffi.new("double[?]", lineMax)
	self.outbuf = ffi.new("double[?]", lineMax)
	self.bufi = 0
	self.inphase = ffi.new("double[?]", cplxSize)
	self.outphase = ffi.new("double[?]", cplxSize)
end

-- shift data already in the "spectrum" global
local function applyFilter (inphase, outphase)
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
	-- loop-merging optimization, not sure if useful
	if shift>=1 then
		for i=0,cplxSize-1 do
			shiftAndSynth(i, outphase)
		end
	else
		for i=cplxSize-1,0,-1 do
			shiftAndSynth(i, outphase)
		end
	end
end

function shiftAndSynth(i, outphase)
	-- processing
	local i2 = math.floor(i*shift+0.5) -- bigger
	if i2<cplxSize and i2>0 then -- only for backward
			synMagn[i2] = anaMagn[i] + synMagn[i2]
			synFreq[i2] = anaFreq[i] * shift
	end
	-- resynthesis
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
			-- revive cdata (inexplicably required, todo narrow down the cause):
			tostring(dbuf); tostring(spectrum)
			fftlib.fftw_execute(r2c)
			applyFilter (self.inphase, self.outphase)
			fftlib.fftw_execute(c2r)
			applyWindow(dbuf)
			for j=0,fftSize-1 do
				self.outbuf[wrap(self.bufi+j)] =
				 self.outbuf[wrap(self.bufi+j)] + dbuf[j]
			end
		end
		self.bufi = wrap(self.bufi+1)
	end
end

plugin.manageParams {
	{
		name = "Shift";
		changed = function(val) 
			if val<0.5 then
				shift = (val+0.1)/0.6
			else
				shift = val*8-3
			end
		end;
	};
}
