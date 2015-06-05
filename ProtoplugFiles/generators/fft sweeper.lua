--[[
name: FFT sweeper
description: testing
author: osar.fr
--]]

require "include/protoplug"

fftlib = script.ffiLoad("libfftw3.so.3", "libfftw3-3")

ffi.cdef[[
typedef enum {
	FFTW_R2HC=0, FFTW_HC2R=1, FFTW_DHT=2,
	FFTW_REDFT00=3, FFTW_REDFT01=4, FFTW_REDFT10=5, FFTW_REDFT11=6,
	FFTW_RODFT00=7, FFTW_RODFT01=8, FFTW_RODFT10=9, FFTW_RODFT11=10
} fftw_r2r_kind;
void *fftw_plan_r2r_1d(int n, double *in, double *out, fftw_r2r_kind kind, unsigned int flags);
void fftw_execute(void *plan);
]]
fftsz = 1024
winsz = 1000
fd  = ffi.new("double[?]", fftsz) -- halfcomplex freq domain
td1 = ffi.new("double[?]", fftsz) -- time domain
td2 = ffi.new("double[?]", fftsz) -- time domain (alternating)
hw  = ffi.new("double[?]", fftsz) -- Hann window function
plan1 = fftlib.fftw_plan_r2r_1d(fftsz, fd, td1, 1, 64)
plan2 = fftlib.fftw_plan_r2r_1d(fftsz, fd, td2, 1, 64)

-- prepare Hann window
for i = 0,winsz-1 do
	hw[i] = 0.00003 * (1 - math.cos(2*math.pi*i/(winsz-1)));
end
function ApplyWindow (buf)
	for i = 0,winsz-1 do
		buf[i] = buf[i] * hw[i]
	end
end

cphase = 0

gapper = 0

function FillFD (buf)
	local center = math.sin(cphase)*10+15
	gapper = gapper+1
	if gapper > 1 then gapper = 0 end
	if gapper > 0 then
		--for i = 0,fftsz-1 do
		--	buf[i] = 0
		--end
		--return
		center = center*4
	end
	for i = 0,fftsz-1 do
		local sharm = math.sin(i-center)
		local x = i/(fftsz*0.0004883)
		buf[i] = 10000/((x-center)*(x-center)+10)*sharm*sharm
		buf[i] = buf[i] + 33457/((x-center*8)*(x-center*8)+1000)
		buf[i] = buf[i] + 34321/((x-center*12)*(x-center*12)+1000)
		--buf[i] = buf[i] + 100/((i-center*2)*(i-center*2)+1)
		--buf[i] = buf[i] + 10/((i-center*4)*(i-center*4)+1)
		--if i<center then buf[i] = 0 end
		if i%5==1 then buf[i] = buf[i]*0.1 end
		if i%3==1 then buf[i] = buf[i]*-1 end
		if buf[i] > 10 then buf[i] = 10 end
	end
	cphase = cphase + 0.01
end


FillFD(fd)
fftlib.fftw_execute(plan1)
fftlib.fftw_execute(plan2)
ApplyWindow(td1)
ApplyWindow(td2)
tdpos1 = 0
tdpos2 = winsz*0.5
alt1 = false
alt2 = false

function plugin.processBlock(s, smax)
	for i = 0,smax do
		s[0][i] = td1[tdpos1] + td2[tdpos2]
		s[1][i] = td1[tdpos1] + td2[tdpos2]
		tdpos1 = tdpos1+1
		tdpos2 = tdpos2+1
		if tdpos1 >= winsz then
			tdpos1 = 0
			if alt1 then 
				alt1 = false
				FillFD(fd)
				fftlib.fftw_execute(plan1)
				ApplyWindow(td1)
			else
				alt1 = true
			end
		end
		if tdpos2 >= winsz then
			tdpos2 = 0
			if alt2 then
				alt2 = false
				FillFD(fd)
				fftlib.fftw_execute(plan2)
				ApplyWindow(td2)
			else
				alt2 = true
			end
		end
	end
	return 1
end
