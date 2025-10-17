local state = {}
state.file = "tower_state.json"

-- Lade Zustand
local function load()
    local f = fs.open(state.file,"r")
    if f then
        local content = f.readAll()
        f.close()
        state.data = textutils.unserialize(content) or {}
    else
        state.data = {}
    end
end

-- Speicher Zustand
local function save()
    local f = fs.open(state.file,"w")
    if f then
        f.write(textutils.serialize(state.data))
        f.close()
    end
end

-- Fortschritt pro Floor
function state.getProgress(floor)
    return state.data[floor] or 0
end

function state.setProgress(floor, value)
    state.data[floor] = math.min(math.max(value,0),1)
    save()
end

-- Sprache
function state.getLang()
    return state.data.lang or "de"
end

function state.setLang(lang)
    state.data.lang = lang
    save()
end

-- Initialisierung
load()
return state
