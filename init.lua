-- Init Script für Tablet
local monitor = peripheral.wrap("top") or peripheral.find("monitor")
if not monitor then error("Kein Monitor gefunden!") end

local state = require("tower_state")
local textsize = require("textsize")
textsize.setOptimalTextScale(monitor)

local w,h = monitor.getSize()

-- Sprachwahl
local languages = {"de","en","pl"}
local langLabels = {de="Deutsch", en="English", pl="Polski"}
local selectedLang = state.getLang()

local function drawLangSelection()
    monitor.clear()
    monitor.setBackgroundColor(colors.black)
    monitor.setTextColor(colors.white)
    monitor.setCursorPos(2,2)
    monitor.write("Bitte Sprache wählen / Please select language / Wybierz język:")
    local startY = 4
    for i,lang in ipairs(languages) do
        monitor.setCursorPos(4, startY + (i-1)*2)
        if lang == selectedLang then
            monitor.setBackgroundColor(colors.gray)
            monitor.setTextColor(colors.white)
        else
            monitor.setBackgroundColor(colors.black)
            monitor.setTextColor(colors.white)
        end
        monitor.write(langLabels[lang])
        monitor.setBackgroundColor(colors.black)
    end
end

local function handleLangTouch()
    while true do
        local event, side, x, y = os.pullEvent("monitor_touch")
        for i,lang in ipairs(languages) do
            local btnX1, btnY1 = 4, 4 + (i-1)*2
            local btnX2, btnY2 = 4 + #langLabels[lang], btnY1
            if x>=btnX1 and x<=btnX2 and y==btnY1 then
                state.setLang(lang)
                selectedLang = lang
                return
            end
        end
    end
end

-- Anzeige der Sprachwahl
drawLangSelection()
handleLangTouch()

-- Danach Tower-Visual starten
os.run({}, "tower_visual")
