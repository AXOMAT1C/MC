-- tower_visual.lua
local monitor = peripheral.wrap("top")
local tower_state = require("tower_state")
local textsize = require("textsize")

local floors = {"DACH","WOOD","FARMS","ITEM","DEFENSE","STORAGE","EN/ME"}
local w,h = monitor.getSize()
local colorsFloor = {DACH=colors.lightBlue,WOOD=colors.brown,FARMS=colors.green,ITEM=colors.yellow,DEFENSE=colors.red,STORAGE=colors.orange,["EN/ME"]=colors.purple}

local maxBarLength = textsize.getBarLength("desktop")
local buttonWidth = math.floor(w / #floors)
local buttonHeight = 3

monitor.clear()
monitor.setBackgroundColor(colors.black)
monitor.setTextColor(colors.white)

local function drawFrame()
    for y=1,h do
        monitor.setCursorPos(1,y)
        if y==1 or y==h then
            monitor.write("+" .. string.rep("-", w-2) .. "+")
        else
            monitor.write("|" .. string.rep(" ", w-2) .. "|")
        end
    end
end

local function drawHeader()
    monitor.setCursorPos(3,1)
    monitor.write("TOWER DASHBOARD")
end

local function drawProgress()
    for i,floor in ipairs(floors) do
        local y = i*2
        local progress = tower_state.getProgress(floor)
        local filled = math.floor(progress*maxBarLength)
        monitor.setCursorPos(3, y)
        monitor.setBackgroundColor(colorsFloor[floor] or colors.white)
        monitor.write(string.rep(" ", filled))
        monitor.setBackgroundColor(colors.black)
        monitor.write(string.rep("-", maxBarLength-filled) .. " " .. floor .. string.format(" %.0f%%", progress*100))
    end
end

local function drawButtons()
    for i,floor in ipairs(floors) do
        local bx = (i-1)*buttonWidth+1
        local by = h-buttonHeight+1
        monitor.setBackgroundColor(colors.gray)
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

local function handleTouch()
    while true do
        local event, side, x, y = os.pullEvent("monitor_touch")
        for i,floor in ipairs(floors) do
            local bx = (i-1)*buttonWidth+1
            local by = h-buttonHeight+1
            if x>=bx and x<bx+buttonWidth and y>=by and y<by+buttonHeight then
                local current = tower_state.getProgress(floor)
                tower_state.setProgress(floor, math.min(current+0.1,1))
                drawButtons()
            end
        end
    end
end

drawFrame()
drawHeader()
drawButtons()

parallel.waitForAny(
    function()
        while true do
            drawProgress()
            sleep(1)
        end
    end,
    handleTouch
)
