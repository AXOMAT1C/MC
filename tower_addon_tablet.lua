-- tower_addon_tablet.lua
local monitor = peripheral.wrap("top")
local w,h = monitor.getSize()
monitor.clear()
monitor.setBackgroundColor(colors.black)
monitor.setTextColor(colors.white)

local tower_state = require("tower_state")
local floors = {"DACH","WOOD","FARMS","ITEM","DEFENSE","STORAGE","EN/ME"}
local tabletBarLength = math.min(20, w-2)

rednet.open("back")

local colorsFloor = {
    DACH = colors.lightBlue,
    WOOD = colors.brown,
    FARMS = colors.green,
    ITEM = colors.yellow,
    DEFENSE = colors.red,
    STORAGE = colors.orange,
    ["EN/ME"] = colors.purple
}

local function drawTabletUI()
    monitor.clear()
    for i,floor in ipairs(floors) do
        local y = i
        if y>h then break end
        local progress = tower_state.getProgress(floor)
        local filled = math.floor(progress * tabletBarLength)
        monitor.setCursorPos(2, y)
        monitor.setBackgroundColor(colorsFloor[floor] or colors.white)
        monitor.write(string.rep(" ", filled))
        monitor.setBackgroundColor(colors.black)
        monitor.write(string.rep("-", tabletBarLength - filled) .. " " .. floor .. string.format(" %.0f%%", progress*100))
    end
end

while true do
    local senderId, message = rednet.receive()
    if message.type == "update" then
        for floor,value in pairs(message.data) do
            tower_state.setProgress(floor, value)
        end
    end
    drawTabletUI()
    sleep(1)
end
