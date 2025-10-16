-- tower_visual.lua (dynamisch + safe)
local monitor = peripheral.wrap("top") or peripheral.find("monitor")
if not monitor then error("Kein Monitor gefunden!") end

-- Monitorgröße dynamisch abrufen
local w,h = 51,19 -- Default fallback
if monitor.getSize then
    local mw,mh = monitor.getSize()
    if mw and mh then
        w,h = mw,mh
    end
end

local tower_state = require("tower_state")
local textsize = require("text_size")

-- Floors
local floors = {"DACH","WOOD","FARMS","ITEM","DEFENSE","STORAGE","EN/ME"}
local colorsFloor = {
    DACH=colors.lightBlue,WOOD=colors.brown,FARMS=colors.green,
    ITEM=colors.yellow,DEFENSE=colors.red,STORAGE=colors.orange,["EN/ME"]=colors.purple
}

-- Balkenlängen dynamisch
local maxBarLength = math.min(30, w-4)
local buttonHeight = 3
local buttonWidth = math.floor(w / #floors)

-- ASCII Roadmap
local roadmap = {
"Y=319+  -- DACH / SKY / OPTIONAL",
"+--------------------------------------------------------+",
"| T: Teleporter  E: End Access  R: Decorative Roof      |",
"| G: Glass Roof  S: Sky Lights  F: Optional Sky Farms    |",
"+--------------------------------------------------------+",
"Y=64+   -- WOOD / Dekoration",
"+--------------------------------------------------------+",
"| L: Logs  T: Trees  D: Decorative Wood Blocks          |",
"| R: Roof Support / Sky-Top Layer                        |",
"+--------------------------------------------------------+",
"Y=40-63  -- FARMS",
"+--------------------------------------------------------+",
"| P1: Plant 1  P2: Plant 2  C: Crops                     |",
"| A1: Animal 1  A2: Animal 2                             |",
"| B1: Bee 1     B2: Bee 2                                 |",
"| AQ: Aquaculture  W1: Water Gen 1  W2: Water Gen 2     |",
"+--------------------------------------------------------+",
"Y=20-39  -- ITEM",
"+--------------------------------------------------------+",
"| CB: Create Belts / Conveyors  AE: AE2 I/O Terminals    |",
"| XN: XNet Links / Mod Output Channels                    |",
"| CS: Crafting Stations / Auto-Crafters                  |",
"+--------------------------------------------------------+",
"Y=10-19  -- DEFENSE",
"+--------------------------------------------------------+",
"| T: Turrets / SecurityCraft Towers                       |",
"| W: Walls / Shields / Protective Barriers               |",
"+--------------------------------------------------------+",
"Y=5-9   -- STORAGE",
"+--------------------------------------------------------+",
"| D: Drawers  F: Functional Storage  B: Buffers          |",
"| DK: Dank Storage / Intermediate Storage                |",
"+--------------------------------------------------------+",
"Y=-58-4  -- EN / ME",
"+--------------------------------------------------------+",
"| E: Powah Generators / Flux Capacitors                  |",
"| M: AE2 Core / Terminals                                 |",
"| S: ME Storage Cells 64k / 256k / 1024k                 |",
"| C: Crafting Terminals / Automation Blocks             |",
"| Cables: Energy Distribution Channels                   |",
"+--------------------------------------------------------+"
}

-- Frame
local function drawFrame()
    monitor.clear()
    for y=1,h do
        monitor.setCursorPos(1,y)
        if y==1 or y==h then
            monitor.write("+" .. string.rep("-", w-2) .. "+")
        else
            monitor.write("|" .. string.rep(" ", w-2) .. "|")
        end
    end
end

-- ASCII Roadmap anzeigen
local function drawRoadmap()
    for i,line in ipairs(roadmap) do
        if i <= h-buttonHeight-1 then
            monitor.setCursorPos(2, i)
            monitor.setBackgroundColor(colors.black)
            monitor.setTextColor(colors.white)
            monitor.write(string.sub(line,1,w-2))
        end
    end
end

-- Fortschrittsbalken
local function drawProgress()
    local startY = math.min(#roadmap+1, h-buttonHeight-#floors-1)
    for i,floor in ipairs(floors) do
        local y = startY + i
        if y>h-buttonHeight then break end
        local progress = tower_state.getProgress(floor)
        local filled = math.floor(progress*maxBarLength)
        monitor.setCursorPos(2, y)
        monitor.setBackgroundColor(colorsFloor[floor] or colors.white)
        monitor.write(string.rep(" ", filled))
        monitor.setBackgroundColor(colors.black)
        monitor.write(string.rep("-", maxBarLength-filled) .. " " .. floor .. string.format(" %.0f%%", progress*100))
    end
end

-- Buttons + / -
local function drawButtons()
    local by = h-buttonHeight+1
    for i,floor in ipairs(floors) do
        local bx = (i-1)*buttonWidth+1
        monitor.setBackgroundColor(colors.gray)
        for j=0,buttonHeight-1 do
            monitor.setCursorPos(bx, by+j)
            monitor.write(string.rep(" ", buttonWidth))
        end
        monitor.setCursorPos(bx+1, by+1)
        monitor.setTextColor(colors.white)
        monitor.write(floor .. " [+/-]")
    end
end

-- Touch Event
local function handleTouch()
    while true do
        local event, side, x, y = os.pullEvent("monitor_touch")
        local by = h-buttonHeight+1
        for i,floor in ipairs(floors) do
            local bx = (i-1)*buttonWidth+1
            if x>=bx and x<bx+buttonWidth and y>=by and y<by+buttonHeight then
                local current = tower_state.getProgress(floor)
                if x < bx + buttonWidth/2 then
                    tower_state.setProgress(floor, math.max(current-0.1,0))
                else
                    tower_state.setProgress(floor, math.min(current+0.1,1))
                end
            end
        end
        drawButtons()
    end
end

-- Main
drawFrame()
drawRoadmap()
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
