-- textsize.lua
local textsize = {}

function textsize.setOptimalTextScale(monitor)
    if not monitor.getSize or not monitor.setTextScale then return end

    local w,h = monitor.getSize()
    -- Dynamische Skalierung je nach Bildschirmgröße
    if w < 40 or h < 20 then
        monitor.setTextScale(0.5)  -- kleinster Text
    elseif w < 60 or h < 30 then
        monitor.setTextScale(1)    -- normal
    elseif w < 80 or h < 40 then
        monitor.setTextScale(1.5)  -- mittel
    else
        monitor.setTextScale(2)    -- groß
    end
end

return textsize
