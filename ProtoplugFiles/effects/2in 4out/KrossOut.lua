require "include/protoplug"

local pos

function plugin.processBlock (samples, smax)
	for i = 0, smax do
		samples[0][i] = samples[0][i] * (1-pos)
		samples[1][i] = samples[1][i] * (1-pos)
		samples[2][i] = samples[0][i] * pos
		samples[3][i] = samples[1][i] * pos
	end
end

params = plugin.manageParams {
	{
		name = "Position";
		min = 0;
		max = 1;
		changed = function (val) pos = val end;
	};
}
