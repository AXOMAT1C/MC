-- touchscreen.lua
local monitor = peripheral.wrap("top")
local w,h = monitor.getSize()
monitor.clear()
monitor.setBackgroundColor(colors.black)
monitor.setTextColor(colors.white)

local floors = {"DACH","WOOD","FARMS","ITEM","DEFENSE","STORAGE","EN/ME"}
local tower_state = require("tower_state")

local buttonWidth = math.floor(w / #floors)
local buttonHeight = 3

local function drawButtons()
    for i,floor in ipairs(floors) do
        local bx = (i-1)*buttonWidth+1
        local by = h-buttonHeight+1
        local color = colors.gray
        monitor.setBackgroundColor(color)
        for j=0,buttonHeight-1 do
            monitor.setCursorPos(bx, by+j)
            monitor.write(string.rep(" ", buttonWidth))
        end
        local textX = bx + math.floor((buttonWidth - #floor)/2)
        local textY = by + math.floor(buttonHeight/2)
        monitor.setCursorPos(textX, textY)
        monitor.setTextColor(colors.white)
        monitor.write(floor)
    end
end

drawButtons()

while true do
    local event, side, x, y = os.pullEvent("monitor_touch")
    for i,floor in ipairs(floors) do
        local bx = (i-1)*buttonWidth+1
        local by = h-buttonHeight+1
        if x >= bx and x < bx+buttonWidth and y >= by and y < by+buttonHeight then
            local current = tower_state.getProgress(floor)
            tower_state.setProgress(floor, math.min(current + 0.1, 1))
            drawButtons()
        end
    end
end
