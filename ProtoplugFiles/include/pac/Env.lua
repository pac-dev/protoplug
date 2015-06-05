local M = {}
local EnvLinear = {att=0,rel=0,ended=true}
function EnvLinear:init(att,rel)
	self.on = true
	self.ended = false
	self.att = att
	self.att_pos = 0
	self.rel = rel
	self.rel_pos = 0
end
function EnvLinear:release()
	self.on = false
	self.att_pos = 0
	self.rel_pos = 0
end
function EnvLinear:get_amp()
	local ret
	if self.on then
		ret = math.min(1,self.att_pos/self.att)
		self.att_pos = self.att_pos + self.tick_len
	elseif self.rel_pos > self.rel then
		self.ended = true
		return 0
	else
		ret = 1 - self.rel_pos/self.rel
		self.rel_pos = self.rel_pos + self.tick_len
	end
	return ret
end
function EnvLinear:new (o)
	setmetatable(o, self)
	self.__index = self
	plugin.addHandler("prepareToPlay", function() o.tick_len = 1/plugin.getSampleRate() end)
	return o
end

local EnvTri = {att=0,rel=0,ended=true}
function EnvTri:init(att,rel)
	self.on = true
	self.ended = false
	self.att = att
	self.rel = rel
	self.pos = 0
end
function EnvTri:release()
	self.on = false
	self.pos = 0
end
function EnvTri:get_amp()
	local ret
	if self.pos < self.att then
		ret = self.pos/self.att
		self.pos = self.pos + self.tick_len
	elseif self.pos > self.rel + self.att then
		self.ended = true
		return 0
	else
		ret = 1 - (self.pos - self.att)/self.rel
		self.pos = self.pos + self.tick_len
	end
	return ret
end
function EnvTri:new (o)
	setmetatable(o, self)
	self.__index = self
	plugin.addHandler("prepareToPlay", function() o.tick_len = 1/plugin.getSampleRate() end)
	return o
end

M.EnvLinear = EnvLinear
M.EnvTri = EnvTri
return M