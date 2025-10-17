-- tower_state.lua
local state = {}
local path = "tower_state_data"

-- Standardwerte
state.lang = "de"
state.progress = {}

-- Fortschritt setzen und speichern
function state.setProgress(floor, value)
    state.progress[floor] = value
    state.save()
end

function state.getProgress(floor)
    return state.progress[floor] or 0
end

-- Sprache setzen
function state.setLang(lang)
    state.lang = lang
    state.save()
end

-- Sprache holen
function state.getLang()
    return state.lang or "de"
end

-- Speichern: nur Tabellen, Zahlen, Strings
function state.save()
    local file = fs.open(path, "w")
    local data = {
        lang = state.lang,
        progress = state.progress
    }
    file.write(textutils.serialize(data))
    file.close()
end

-- Laden
function state.load()
    if fs.exists(path) then
        local file = fs.open(path, "r")
        local data = textutils.unserialize(file.readAll())
        file.close()
        if data then
            state.lang = data.lang or "de"
            state.progress = data.progress or {}
        end
    end
end

state.load()
return state
