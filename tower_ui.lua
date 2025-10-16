-- tower_ui.lua
-- Zeichnet ASCII Tower Map + Balken + numerische Werte; Mapping von Klicks -> Tasks
local M = {}

-- Translations
local i18n = {
    de = {
        title = "AXOMAT1C TOWER",
        projects = "Projekte",
        lang = "Sprache",
        reset = "Reset",
        floor = "Etage",
        progress = "Fortschritt",
        complete = "Abgeschlossen",
        controls = "Steuerung: Klick=Toggle | L=Sprache | R=Reset"
    },
    en = {
        title = "AXOMAT1C TOWER",
        projects = "Projects",
        lang = "Language",
        reset = "Reset",
        floor = "Floor",
        progress = "Progress",
        complete = "Complete",
        controls = "Controls: Click=Toggle | L=Lang | R=Reset"
    },
    pl = {
        title = "AXOMAT1C TOWER",
        projects = "Projekty",
        lang = "Język",
        reset = "Reset",
        floor = "Piętro",
        progress = "Postęp",
        complete = "Zakończone",
        controls = "Sterowanie: Klik=Toggle | L=Język | R=Reset"
    }
}

-- The big ASCII combined layout the user provided, as a list of lines.
local asciiLayout = {
"Y=319+  -- DACH / SKY / OPTIONAL",
"+--------------------------------------------------------+",
"| T: Teleporter  E: End Access  R: Decorative Roof      |",
"| G: Glass Roof  S: Sky Lights  F: Optional Sky Farms    |",
"+--------------------------------------------------------+",
"",
"Y=64+   -- WOOD / Dekoration",
"+--------------------------------------------------------+",
"| L: Logs  T: Trees  D: Decorative Wood Blocks          |",
"| R: Roof Support / Sky-Top Layer                        |",
"+--------------------------------------------------------+",
"",
"Y=40-63  -- FARMS",
"+--------------------------------------------------------+",
"| P1: Plant 1  P2: Plant 2  C: Crops                     |",
"| A1: Animal 1  A2: Animal 2                             |",
"| B1: Bee 1     B2: Bee 2                                 |",
"| AQ: Aquaculture  W1: Water Gen 1  W2: Water Gen 2     |",
"+--------------------------------------------------------+",
"",
"Y=20-39  -- ITEM",
"+--------------------------------------------------------+",
"| CB: Create Belts / Conveyors  AE: AE2 I/O Terminals    |",
"| XN: XNet Links / Mod Output Channels                    |",
"| CS: Crafting Stations / Auto-Crafters                  |",
"+--------------------------------------------------------+",
"",
"Y=10-19  -- DEFENSE",
"+--------------------------------------------------------+",
"| T: Turrets / SecurityCraft Towers                       |",
"| W: Walls / Shields / Protective Barriers               |",
"+--------------------------------------------------------+",
"",
"Y=5-9   -- STORAGE",
"+--------------------------------------------------------+",
"| D: Drawers  F: Functional Storage  B: Buffers          |",
"| DK: Dank Storage / Intermediate Storage                |",
"+--------------------------------------------------------+",
"",
"Y=-58-4  -- EN / ME",
"+--------------------------------------------------------+",
"| E: Powah Generators / Flux Capacitors                  |",
"| M: AE2 Core / Terminals                                 |",
"| S: ME Storage Cells 64k / 256k / 1024k                 |",
"| C: Crafting Terminals / Automation Blocks             |",
"| Cables: Energy Distribution Channels                   |",
"+--------------------------------------------------------+"
}

-- Utility: find monitor or fallback to term (caller passes monitorTerm)
local function drawProgressBar(monitorTerm, x, y, width, percent)
    percent = math.max(0, math.min(100, percent or 0))
    local fill = math.floor((percent/100) * width)
    monitorTerm.setCursorPos(x, y)
    monitorTerm.write("[")
    for i=1,width do
        if i <= fill then monitorTerm.write("=") else monitorTerm.write(" ") end
    end
    monitorTerm.write("] "..tostring(percent).."%")
end

-- Draw combined interface (left ASCII layout + right task list with bars)
-- monitorTerm: peripheral or term
function M.draw(monitorTerm, state)
    local lang = state.lang or "de"
    local T = i18n[lang] or i18n.de
    local w,h = monitorTerm.getSize()           -- zuerst Monitorgröße holen
    local maxBarLength = math.min(30, w-2)      -- Desktop-Balken
    local tabletBarLength = math.min(20, w-2)   -- Tablet-Balken

    monitorTerm.setBackgroundColor(colors.black)
    monitorTerm.clear()
    monitorTerm.setCursorPos(1,1)
    monitorTerm.write(" "..T.title.."  -  "..T.floor.." "..tostring(state.currentFloor))
    monitorTerm.setCursorPos(1,2)
    monitorTerm.write(string.rep("-", w))

    -- left column width
    local leftW = math.floor(w * 0.52)
    local rightX = leftW + 2

    -- draw ASCII layout in left column starting row 4
    local row = 4
    for i,line in ipairs(asciiLayout) do
        if row <= h-4 then
            monitorTerm.setCursorPos(1, row)
            local s = line
            if #s > leftW then s = string.sub(s,1,leftW) end
            monitorTerm.write(s)
            row = row + 1
        end
    end

    -- right column: task list, with bars + numeric
    local startRow = 4
    local floor = state.floors[state.currentFloor]
    monitorTerm.setCursorPos(rightX, startRow)
    monitorTerm.write(T.projects .. ":")
    local r = startRow + 1
    local idx = 0
    for si, section in ipairs(floor.sections) do
        monitorTerm.setCursorPos(rightX, r); monitorTerm.write("["..(section.name or "Section").."]"); r = r + 1
        for ti, task in ipairs(section.tasks) do
            idx = idx + 1
            local title = task["title_"..lang] or task.title_de or task.title_en or task.id
            local label = string.format("%2d) %s", idx, title)
            monitorTerm.setCursorPos(rightX, r); monitorTerm.write(label)
            -- bar position
            local barW = math.max(12, w - rightX - 20)
            drawProgressBar(monitorTerm, rightX + 18, r, barW, task.progress or 0)
            -- numeric percentage at the end
            monitorTerm.setCursorPos(rightX + 18 + barW + 2, r); monitorTerm.write(tostring(task.progress or 0).."%")
            r = r + 1
            if r > h-4 then break end
        end
        if r > h-4 then break end
    end

    -- footer + controls
    monitorTerm.setCursorPos(1, h-2); monitorTerm.write(string.rep("-", w))
    monitorTerm.setCursorPos(1, h-1); monitorTerm.write(T.controls)
    monitorTerm.setCursorPos(w-30, h-1); monitorTerm.write("Lang: "..string.upper(state.lang).."  ")
end

-- Map click coordinates to section & task indices
-- We map clicks on the right column to the tasks (1..N)
function M.mapClickToTask(monitorTerm, state, x, y)
    local w,h = monitorTerm.getSize()
    local leftW = math.floor(w * 0.52)
    local rightX = leftW + 2
    if x < rightX then
        -- left (ASCII) area clicked: no direct mapping to tasks for now
        return nil
    end

    -- compute which row in the right column was clicked
    local startRow = 4
    local rel = y - startRow + 1
    if rel < 2 then return nil end -- header area
    local idx = 0
    local rowCounter = 2 -- first row after header
    local floor = state.floors[state.currentFloor]
    for si, section in ipairs(floor.sections) do
        rowCounter = rowCounter + 1 -- section title row
        for ti, task in ipairs(section.tasks) do
            idx = idx + 1
            if rowCounter == rel then
                return si, ti
            end
            rowCounter = rowCounter + 1
        end
    end
    return nil
end

return M


