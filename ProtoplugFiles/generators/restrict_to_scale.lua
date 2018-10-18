--[[
name: Restrict to scale
description: MIDI processor VST/AU. Remaps midi notes to key/scale. Scales ripped from Renoise.
author: joule
--]]

require "include/protoplug"

-- scale list with note transposition tables
local scales = {
    { name="None",                keys={0,0,0,0,0,0,0,0,0,0,0,0} },
    { name="Natural Major",       keys={0,-1,0,-1,0,0,-1,0,-1,0,-1,0} },
    { name="Natural Minor",       keys={0,-1,0,0,-1,0,-1,0,0,-1,0,-1} },
    { name="Pentatonic Major",    keys={0,-1,0,-1,0,-1,-1,0,-1,0,-1,1} },
    { name="Pentatonic Minor",    keys={0,-1,-1,0,-1,0,-1,0,-1,-1,0,-1} },
    { name="Egyptian Pentatonic", keys={0,-1,0,-1,1,0,-1,0,-1,-1,0,-1} },
    { name="Blues Major",         keys={0,-1,0,0,0,-1,1,0,-1,0,-1,1} },
    { name="Blues Minor",         keys={0,-1,1,0,-1,0,0,0,-1,-1,0,-1} },
    { name="Whole Tone",          keys={0,-1,0,-1,0,-1,0,-1,0,-1,0,-1} },
    { name="Augmented",           keys={0,-1,1,0,0,-1,1,0,0,-1,1,0} },
    { name="Prometheus",          keys={0,-1,0,-1,0,-1,0,-1,1,0,0,-1} },
    { name="Tritone",             keys={0,0,-1,1,0,-1,0,0,-1,1,0,-1} },
    { name="Harmonic Major",      keys={0,-1,0,-1,0,0,-1,0,0,-1,1,0} },
    { name="Harmonic Minor",      keys={0,-1,0,0,-1,0,-1,0,0,-1,1,0} },
    { name="Melodic Minor",       keys={0,-1,0,0,-1,0,-1,0,-1,0,-1,0} },
    { name="All Minor",           keys={0,-1,0,0,-1,0,-1,0,0,0,0,0} },
    { name="Dorian",              keys={0,-1,0,0,-1,0,-1,0,-1,0,0,-1} },
    { name="Phrygian",            keys={0,0,-1,0,-1,0,-1,0,0,-1,0,-1} },
    { name="Phrygian Dominant",   keys={0,0,-1,-1,0,0,-1,0,0,-1,0,-1} },
    { name="Lydian",              keys={0,-1,0,-1,0,-1,0,0,-1,0,-1,0} },
    { name="Lydian Augmented",    keys={0,-1,0,-1,0,-1,0,-1,0,0,-1,0} },
    { name="Mixolydian",          keys={0,-1,0,-1,0,0,-1,0,-1,0,0,-1} },
    { name="Locrian",             keys={0,0,-1,0,-1,0,0,-1,0,-1,0,-1} },
    { name="Locrian Major",       keys={0,-1,0,-1,0,0,0,-1,0,-1,0,-1} },
    { name="Super Locrian",       keys={0,0,-1,0,0,-1,0,-1,0,-1,0,-1} },
    { name="Neapolitan Major",    keys={0,0,-1,0,-1,0,-1,0,-1,0,-1,0} }, 
    { name="Neapolitan Minor",    keys={0,0,-1,0,-1,0,-1,0,0,-1,-1,0} },
    { name="Romanian Minor",      keys={0,-1,0,0,-1,1,0,0,-1,0,0,-1} },
    { name="Spanish Gypsy",       keys={0,0,-1,1,0,0,-1,0,0,-1,1,0} },
    { name="Hungarian Gypsy",     keys={0,-1,0,0,-1,1,0,0,0,-1,1,0} },
    { name="Enigmatic",           keys={0,0,-1,1,0,-1,0,-1,0,-1,0,0} },
    { name="Overtone",            keys={0,-1,0,-1,0,-1,0,0,-1,0,0,-1} },
    { name="Diminished Half",     keys={0,0,-1,0,0,-1,0,0,-1,0,0,-1} },
    { name="Diminished Whole",    keys={0,-1,0,0,-1,0,0,-1,0,0,-1,0} },
    { name="Spanish Eight-Tone",  keys={0,0,-1,0,0,0,0,-1,0,-1,0,-1} },
    { name="Nine-Tone Scale",     keys={0,-1,0,0,0,-1,0,0,0,0,-1,0} }
}

-- create a scale list for use in parameter list
function tidy_scale_list()
    local scale_list = { }
    for k, v in ipairs(scales) do
        scale_list[k] = v.name
    end
    return scale_list
end

-- keys list
local keys = {
    "C", "C#", "D", "D#",
    "E", "F", "F#", "G",
    "G#", "A", "A#", "B"
}

-- cached parameter values
local selected_key = 0
local selected_scale = 1

-- main block processing
function plugin.processBlock(samples, smax, midiBuf)
    for ev in midiBuf:eachEvent() do
        if ev:isNoteOn() or ev:isNoteOff() then
            ev.setNote(ev, restrict_to_scale(ev.getNote(ev)))
        end	
    end
end

-- remap a note value to the selected scale and key
function restrict_to_scale(note_value)
    note_value = note_value - selected_key
    return note_value + scales[selected_scale].keys[note_value % 12 + 1] + selected_key
end

-- generic table search function
table.find = function(tbl, val)
    for k, v in pairs(tbl) do
        if v == val then
            return k
        end
    end
end

params = plugin.manageParams {
    {
        name = "Key",
        type = "list",
        values = keys,
        default = 1,
        changed = function(val)
                      selected_key = table.find(keys,val) - 1
                  end
    },
    {
        name = "Scale",
        type = "list",
        values = tidy_scale_list(),
        default = 1,
        changed = function(val)
                      selected_scale = table.find(tidy_scale_list(), val)
                  end
    }
}