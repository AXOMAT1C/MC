local monitor = peripheral.wrap("top") or peripheral.find("monitor")
if not monitor then error("Kein Monitor gefunden!") end

local state = require("tower_state")
local w,h = monitor.getSize()

monitor.clear()
monitor.setCursorPos(1,1)
monitor.setBackgroundColor(colors.black)
monitor.setTextColor(colors.white)

monitor.setCursorPos(2,2)
monitor.write("Sprache wählen / Choose Language / Wybierz język")

-- Buttons
local buttonHeight = 3
local buttonWidth = math.floor(w/3)
local languages = {"de","en","pl"}
local labels = {"DE","EN","PL"}

for i,label in ipairs(labels) do
    local x = (i-1)*buttonWidth + 1
    local y = h/2
    monitor.setBackgroundColor(colors.gray)
    for j=0,buttonHeight-1 do
        monitor.setCursorPos(x, y+j)
        monitor.write(string.rep(" ", buttonWidth))
    end
    monitor.setCursorPos(x + 2, y+1)
    monitor.setTextColor(colors.white)
    monitor.write(label)
end

-- Touch Event Handler
while true do
    local event, side, x, y = os.pullEvent("monitor_touch")
    local ybtn = h/2
    for i,langCode in ipairs(languages) do
        local xstart = (i-1)*buttonWidth + 1
        if x>=xstart and x<xstart+buttonWidth and y>=ybtn and y<ybtn+buttonHeight then
            state.setLang(langCode)
            monitor.clear()
            shell.run("tower_visual") -- Starte das Visual direkt nach Auswahl
        end
    end
end
