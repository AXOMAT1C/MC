-- tower_state.lua
local state = {}
local path = "tower_state_data"

-- Defaultwerte
state.lang = state.lang or "de"
state.progress = state.progress or {}  -- Fortschritte der Floors

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

-- Speichern
function state.save()
    local file = fs.open(path, "w")
    -- nur Tabellen, Strings, Zahlen speichern
    file.write(textutils.serialize({
        lang = state.lang,
        progress = state.progress
    }))
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

-- direkt laden beim require
state.load()

return state
