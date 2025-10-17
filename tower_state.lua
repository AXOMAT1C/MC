-- tower_state.lua
local stateFile = "tower_state_data.lua"

local state = {
    currentFloor = 1,
    progress = {},
    lang = "de"
}

-- Lade gespeicherten Zustand
local function loadState()
    if fs.exists(stateFile) then
        local f = fs.open(stateFile,"r")
        local content = f.readAll()
        f.close()
        local ok, loaded = pcall(loadstring(content))
        if ok and type(loaded) == "table" then
            for k,v in pairs(loaded) do
                state[k] = v
            end
        end
    end
end

-- Speichere Zustand
local function saveState()
    local f = fs.open(stateFile,"w")
    f.write("return "..textutils.serialize(state))
    f.close()
end

-- Fortschritt abfragen
function state.getProgress(floor)
    return state.progress[floor] or 0
end

-- Fortschritt setzen
function state.setProgress(floor, value)
    state.progress[floor] = value
    saveState()
end

-- Sprache abfragen
function state.getLang()
    return state.lang or "de"
end

-- Sprache setzen
function state.setLang(code)
    state.lang = code
    saveState()
end

-- Initial laden
loadState()

return state
