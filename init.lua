local package = package or _G.package

package.path = "/rom/programs/?.lua;" .. package.path

local i18n = require("i18n")
local texts = i18n.getTexts()
local monitor = peripheral.wrap("top") or peripheral.find("monitor")
if not monitor then error("Kein Monitor gefunden!") end

local state = require("tower_state")
local textsize = require("textsize")
textsize.setOptimalTextScale(monitor)

local w,h = monitor.getSize()
local languages = {"de","en","pl"}
local langLabels = {de="Deutsch", en="English", pl="Polski"}

local function drawLangSelection(selected)
    monitor.clear()
    monitor.setBackgroundColor(colors.black)
    monitor.setTextColor(colors.white)
    monitor.setCursorPos(2,2)
    monitor.write("Bitte Sprache wählen / Please select language / Wybierz język:")
    for i,lang in ipairs(languages) do
        monitor.setCursorPos(4, 4 + (i-1)*2)
        if lang == selected then
            monitor.setBackgroundColor(colors.gray)
        else
            monitor.setBackgroundColor(colors.black)
        end
        monitor.setTextColor(colors.white)
        monitor.write(langLabels[lang])
        monitor.setBackgroundColor(colors.black)
    end
end

-- initiale Anzeige
local selectedLang = state.getLang()
drawLangSelection(selectedLang)

-- Touch Event
while true do
    local event, side, x, y = os.pullEvent("monitor_touch")
    for i,lang in ipairs(languages) do
        local btnX1, btnY1 = 4, 4 + (i-1)*2
        local btnX2, btnY2 = 4 + #langLabels[lang], btnY1
        if x>=btnX1 and x<=btnX2 and y==btnY1 then
            state.setLang(lang)
            selectedLang = lang
            drawLangSelection(selectedLang)
            os.run({}, "tower_visual") -- Tower Visual starten
            return
        end
    end
end
