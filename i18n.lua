package.path = "/rom/?.lua;/rom/?/init.lua;" .. package.path



-- i18n.lua
local i18n = {}
local currentLang = "de"
local cache = {}

-- Ermittle Pfad der aktuellen Datei (funktioniert in CC)
local function getScriptDir()
    local path = shell.getRunningProgram()
    return fs.getDir(path)
end

local baseDir = getScriptDir()

function i18n.setLang(lang)
    currentLang = lang
    local path = fs.combine(baseDir, "i18n_" .. lang .. ".lua")
    if not fs.exists(path) then
        print("⚠️ Sprachdatei fehlt: " .. path)
        path = fs.combine(baseDir, "i18n_de.lua")
        currentLang = "de"
    end

    local ok, data = pcall(dofile, path)
    if ok and type(data) == "table" then
        cache[currentLang] = data
    else
        print("⚠️ Fehler beim Laden von " .. path)
    end
end

function i18n.getLang() return currentLang end
function i18n.getTexts() return cache[currentLang] or {} end

i18n.setLang(currentLang)
return i18n
