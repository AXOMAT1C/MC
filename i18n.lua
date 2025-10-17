-- i18n.lua
local i18n = {}
local currentLang = "de"
local cache = {}

function i18n.setLang(lang)
    currentLang = lang
    local path = "i18n_" .. lang .. ".lua"
    local ok, data = pcall(dofile, path)
    if ok and type(data) == "table" then
        cache[lang] = data
    else
        print("⚠️ Konnte '" .. path .. "' nicht laden. Fallback: Deutsch")
        cache.de = dofile("i18n_de.lua")
        currentLang = "de"
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
