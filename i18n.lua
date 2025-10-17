local i18n = require("i18n")
local texts = i18n.getTexts()
-- i18n.lua
local i18n = {}
local currentLang = "de"
local cache = {}

-- Liste der unterstützten Sprachen
local supportedLangs = { "de", "en", "pl" }

-- Setzt die Sprache
function i18n.setLang(lang)
    -- prüfen, ob Sprache unterstützt wird
    local valid = false
    for _, l in ipairs(supportedLangs) do
        if l == lang then valid = true break end
    end
    if not valid then
        print("⚠️ Sprache nicht unterstützt, Fallback: Deutsch")
        lang = "de"
    end

    currentLang = lang
    local path = "/rom/programs/i18n_" .. lang .. ".lua"

    -- Prüfen, ob Datei existiert
    if not fs.exists(path) then
        print("⚠️ Sprachdatei fehlt: " .. path .. " → fallback auf Deutsch")
        path = "/rom/programs/i18n_de.lua"
        currentLang = "de"
    end

    local ok, data = pcall(dofile, path)
    if ok and type(data) == "table" then
        cache[currentLang] = data
    else
        error("Fehler beim Laden der Sprachdatei: " .. path)
    end
end

-- Liefert die aktuelle Sprache
function i18n.getLang()
    return currentLang
end

-- Liefert die Texte für die aktuelle Sprache
function i18n.getTexts()
    return cache[currentLang] or {}
end

-- Standardmäßig Deutsch laden
i18n.setLang(currentLang)

return i18n
