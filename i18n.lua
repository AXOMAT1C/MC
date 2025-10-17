local i18n = {}
local currentLang = "de"
local cache = {}

function i18n.setLang(lang)
    currentLang = lang
    local path = "/rom/programs/i18n_" .. lang .. ".lua"  -- <--- absoluter Pfad
    if not fs.exists(path) then
        print("⚠️ Sprachdatei fehlt: " .. path)
        path = "/rom/programs/i18n_de.lua"
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

-- Standardmäßig Deutsch laden
i18n.setLang(currentLang)

return i18n
