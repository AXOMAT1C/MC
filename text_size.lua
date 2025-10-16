-- textsize.lua
local monitor = peripheral.find("monitor")
local w,h = 51,19
if monitor then w,h = monitor.getSize() end

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
