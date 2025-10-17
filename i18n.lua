-- i18n.lua
local i18n = {}
local currentLang = "de"
local cache = {}

function i18n.setLang(lang)
    currentLang = lang
    local ok, data = pcall(require, "i18n_" .. lang)
    if ok and type(data) == "table" then
        cache[lang] = data
    else
        error("Fehler: Sprachdatei 'i18n_" .. lang .. ".lua' nicht gefunden oder ungültig!")
    end
end

function i18n.getLang()
    return currentLang
end

function i18n.getTexts()
    return cache[currentLang] or {}
end

-- Standardmäßig Deutsch laden
i18n.setLang(currentLang)

return i18n
