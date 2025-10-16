-- tower_visual.lua
local monitor = peripheral.wrap("top")
local w,h = monitor.getSize()

monitor.clear()
monitor.setBackgroundColor(colors.black)
monitor.setTextColor(colors.white)

-- Funktion für Balken
local function drawBar(x, y, length, progress, color)
    local filled = math.floor(progress * length)
    monitor.setCursorPos(x, y)
    monitor.setBackgroundColor(color)
    monitor.write(string.rep(" ", filled))
    monitor.setBackgroundColor(colors.black)
    monitor.write(string.rep(" ", length - filled))
end

-- Beispiel-Frame
local function drawFrame()
    for i=1,h do
        monitor.setCursorPos(1,i)
        if i==1 or i==h then
            monitor.write("+" .. string.rep("-", w-2) .. "+")
        else
            monitor.write("|" .. string.rep(" ", w-2) .. "|")
        end
    end
end

-- Fancy Beispiel
drawFrame()
drawBar(3, 3, w-6, 0.6, colors.green) -- Fortschrittsbalken 60%
drawBar(3, 5, w-6, 0.3, colors.red)   -- Fortschrittsbalken 30%
