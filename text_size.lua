-- text_size.lua
local monitor = peripheral.wrap("top")
local w,h = monitor.getSize()
monitor.clear()
monitor.setBackgroundColor(colors.black)
monitor.setTextColor(colors.white)

-- Einfacher Banner-Text
local function drawLargeText(text, x, y)
    local letters = {
        A = {"  #  "," # # ","#####","#   #","#   #"},
        B = {"#### ","#   #","#   #","#### ","#   #","#   #","#### "},
        C = {" ####","#    ","#    ","#    "," ####"},
        -- weitere Buchstaben hinzufügen nach Bedarf
    }

    for row=1,5 do
        monitor.setCursorPos(x, y+row-1)
        for i=1,#text do
            local char = text:sub(i,i):upper()
            local pattern = letters[char] or {" "} -- Leerzeichen für unbekannte Buchstaben
            monitor.write(pattern[row] or "     ")
        end
    end
end

-- Beispiel
drawLargeText("AXOMAT1C", 1, 1)
