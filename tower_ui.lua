
-- tower_ui.lua
local monitor = peripheral.wrap("top")
local tower_state = require("tower_state")
local textsize = require("textsize")

local floors = {"DACH","WOOD","FARMS","ITEM","DEFENSE","STORAGE","EN/ME"}
local colorsFloor = {DACH=colors.lightBlue,WOOD=colors.brown,FARMS=colors.green,ITEM=colors.yellow,DEFENSE=colors.red,STORAGE=colors.orange,["EN/ME"]=colors.purple}

local maxBarLength = textsize.getBarLength("desktop")

monitor.clear()
monitor.setBackgroundColor(colors.black)
monitor.setTextColor(colors.white)

local function drawProgress()
    monitor.clear()
    for i,floor in ipairs(floors) do
        local y = i*2
        local progress = tower_state.getProgress(floor)
        local filled = math.floor(progress * maxBarLength)
        monitor.setCursorPos(2, y)
        monitor.setBackgroundColor(colorsFloor[floor] or colors.white)
        monitor.write(string.rep(" ", filled))
        monitor.setBackgroundColor(colors.black)
        monitor.write(string.rep("-", maxBarLength-filled) .. " " .. floor .. string.format(" %.0f%%", progress*100))
    end
end

while true do
    drawProgress()
    sleep(1)
end
