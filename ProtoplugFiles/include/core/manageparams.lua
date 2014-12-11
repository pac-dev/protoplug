-- Manage Params
-- takes a list of parameter descriptions and manages all the parameter overrides.
--[[ example usage :

params = plugin.manageParams {
	Harshness = {
		max = 510;
		changed = function(val) DoSomethingWithNewValue(val) end;
	};
	["Wave Style"] = {
		type = "list";
		values = {"peaky"; "siney"; "wavey"};
		changed = function(val) myVar = var end;
	};
}
--]]

local util = require "include/luautil"
local script = require "include/core/script"

local paramConstructors = 
{
	double = function(param)
		param.min = param.min or 0
		param.max = param.max or 1
		param.showDecimals = param.showDecimals or 4
		param.getText = function()
			return tostring(
				util.roundDecimal(
					plugin.getParameter(param.index)*(param.max-param.min)+param.min
				,param.showDecimals)
			)
		end
		param.getValue = function()
			return plugin.getParameter(param.index)*(param.max-param.min)+param.min
		end
		param.Value2Raw = function(val)
			return (val-param.min)/(param.max-param.min)
		end
		return param
	end;
	
	int = function(param)
		param.min = param.min or 0
		param.max = param.max or 127
		param.getText = function()
			return tostring(
				math.floor(plugin.getParameter(param.index)*(param.max-param.min)+param.min)
			)
		end
		param.getValue = function()
			return math.floor(plugin.getParameter(param.index)*(param.max-param.min)+param.min)
		end
		param.Value2Raw = function(val)
			return (val-param.min)/(param.max-param.min)
		end
		return param
	end;
	
	list = function(param)
		param.getText = function()
			local i = plugin.getParameter(param.index)*(#param.values-0.1)+1
			return tostring(param.values[math.floor(i)])
		end
		param.getValue = function()
			local i = plugin.getParameter(param.index)*(#param.values-0.1)+1
			return param.values[math.floor(i)]
		end
		param.getKey = function()
			return plugin.getParameter(param.index)*(#param.values-0.1)+1
		end
		param.Value2Raw = function(val)
			for k,v in ipairs(param.values) do
				if v==val then
					return (k-1)/(#param.values-0.5)
				end
			end
			error ("value "..val.." not in value list for "..param.key)
		end
		return param
	end;
}


return function(args)
	local params = {}
	local index2param = {}
	
	for key, param in pairs(args) do
		param.type = param.type or "double"
		param.index = key - 1
		param = paramConstructors[param.type](param)

		if type(param.name) ~= "string" then
			param.name = ("Param %i (%s)"):format(param.index, param.type)
		end

		param.set = function(val)
			plugin.setParameter(param.index, param.Value2Raw(val))
			param.changed(param.getValue())
		end
		params[key] = param
		index2param[param.index] = param
	end

	function plugin.getParameterName(index)
		local param = index2param[index]
		if param then
			return param.name
		end
	end

	function plugin.getParameterText(index)
		local param = index2param[index]
		if param then
			return param.getText()
		end
	end
	
	function plugin.parameterText2Double(index, text)
		local param = index2param[index]
		if param then
			return param.Value2Raw(text)
		end
	end

	function plugin.paramChanged(index)
		local param = index2param[index]
		if  param and param.changed then
			param.changed(param.getValue())
		end
	end
	
	local function iter (params, cur)
		local k,v = next(params, cur)
		while v and type(v)~="table" do
			k,v = next(params, k)
		end
		return k, v
	end
	
	function params.each()
		return iter, params, nil
	end
	
	function params.resetToDefaults()
		for key, param in pairs(args) do
			if type(param)=="table" then
				plugin.setParameter(param.index, param.Value2Raw(param.default))
				param.changed(param.getValue())
			end
		end
	end
	
	script.addHandler("init", function ()
		for key, param in params.each() do
			param.changed(param.getValue())
		end
	end)
	
	return params;
end
