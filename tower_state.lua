local stateFile = "tower_state.dat"

local state = {
    lang = "de",
    progress = {} -- z.B. {DACH=0.5, WOOD=0.2,...}
}

-- Lade State
local function load()
    if fs.exists(stateFile) then
        local f = fs.open(stateFile,"r")
        state = textutils.unserialize(f.readAll()) or state
        f.close()
    end
end

-- Speichere State
local function save()
    local f = fs.open(stateFile,"w")
    f.write(textutils.serialize(state))
    f.close()
end

-- Set Progress
function state.setProgress(floor,val)
    state.progress[floor] = math.min(math.max(val,0),1)
    save()
end

-- Get Progress
function state.getProgress(floor)
    return state.progress[floor] or 0
end

-- Set Language
function state.setLang(l)
    state.lang = l
    save()
end

load()
return state
