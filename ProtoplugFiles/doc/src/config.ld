-- ldoc configuration file
-- works with ldoc 1.4.2 (http://stevedonovan.github.io/ldoc/)

title = "Protoplug Lua API Reference"
project = "protoplug"
description = [[
Protoplug Lua API Reference
]]

local function softenPrefix(s)
	if s:find("^%b<>.-[%.:][^%.%:]-$") then
		-- already wrapped function : leave wrap outisde
		return s:gsub("^(%b<>)(.-)([%.:])([^%.%:]-)%((.-)$", "%1<span class=\"proto_prefix\">%2</span>%3%4%(%5")
	elseif s:find("^.-[%.:][^%.%:]-%(.-$") then
		-- function : allow for dots in optional parameter values
		return s:gsub("^(.-)([%.:])([^%.%:]-)%((.-)$", "<span class=\"proto_prefix\">%1</span>%2%3%(%4")
	elseif s:find("[%.:][^%.%:]-$") then
		return "<span class=\"proto_prefix\">"..s:gsub("([%.:])([^%.%:]-)$", "</span>%1%2")
	else
		return s
	end
end

local forcePrefix = {"plugin", "script", "gui", "midi", "polyGen", "stereoFx"}
local function formatName(item, default_display_name)
	for _, v in ipairs(forcePrefix) do
		if item.module.name == v then
			-- display the prefix on globals to be more explicit
			if item.tags.display then
				return item.tags.display[1].." "..item.args
			else
				return item.module.name.."."..default_display_name(item)
			end
		end
	end
	if item.tags.constructor then
		-- constructors that are a metatable __call 
		return item.module.name.." "..item.args
	elseif #default_display_name(item) >100 then
		-- auto wrap ridiculously long names (it's ugly but better than nothing)
		return '<span class="wrapman">'..(item.display_name or item.name)..'<br> '..item.args..'</span>'
	elseif #default_display_name(item) >60 then
		-- manually wrap slightly long names
		return (item.display_name or item.name)..'<br> '..item.args
	end
	-- mostly class/classmod methods fall into the default display
	return default_display_name(item)
end

custom_display_name_handler = function(item, default_display_name)
	return softenPrefix(formatName(item, default_display_name))
end

custom_tags = { { "display", hidden = true } }
new_type("simplefield","Fields")
new_type("predefined","Predefined values")

file = {
	'../../include/core/plugin.lua';
	'../../include/core/script.lua';
	'../../include/core/midi.lua';
	'../../include/core/gui.lua';
	'../../include/core/polygen.lua';
	'../../include/core/stereofx.lua';
	'../../include/protojuce';
}
examples = {
	'../../effects/classic-filter.lua';
	'../../generators/sine-organ.lua';
	'../../generators/midi-chordify.lua';
	'../../generators/sinemouse-demo.lua';
	'../../generators/soundfile-test.lua';
}

format = 'markdown'
style = true
template = true
