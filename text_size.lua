-- textsize.lua
-- Verwaltet Balkenlängen für Desktop und Tablet
local monitor = peripheral.find("monitor") -- falls kein spezielles Side angegeben
local w,h = 51,19

if monitor then
    w,h = monitor.getSize()
end

-- Balkenlängen
local sizes = {
    desktop = math.min(30, w-2),
    tablet  = math.min(20, w-2)
}

local function getBarLength(device)
    return sizes[device] or sizes.desktop
end

return {
    getBarLength = getBarLength
}
