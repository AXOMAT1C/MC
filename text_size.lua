local text_size = {}

function textsize.setOptimalTextScale(mon)
    local w,h = mon.getSize()
    local scale = 1
    while scale < 5 do
        mon.setTextScale(scale)
        local tw,th = mon.getSize()
        if tw>w or th>h then break end
        scale = scale + 0.5
    end
    mon.setTextScale(scale-0.5)
end

return textsize
