-- tower_core.lua
-- Hauptskript: verbindet modules, startet UI, Event-loop & Rednet listener parallel

local state_mod = dofile("tower_state.lua")
local ui = dofile("tower_ui.lua")
local logic = dofile("tower_logic.lua")
local tablet = dofile("tower_addon_tablet.lua")

-- load state
local state = state_mod.loadState()

-- find monitor peripheral; fallback to term
local monitor = nil
local useTerm = false
if peripheral and peripheral.getNames then
    for _, name in pairs(peripheral.getNames()) do
        if peripheral.getType(name) == "monitor" then
            monitor = peripheral.wrap(name)
            break
        end
    end
end
if not monitor then
    monitor = term
    useTerm = true
    print("Kein Monitor gefunden. Nutze lokalen Bildschirm.")
end

-- prepare monitor (if peripheral supports colors/scales)
pcall(function()
    if monitor.setTextScale then pcall(function() monitor.setTextScale(1) end) end
end)

-- initial draw
ui.draw(monitor, state)

-- attempt to open any modem for rednet (tablet module will also try)
if peripheral and peripheral.getNames then
    for _, name in pairs(peripheral.getNames()) do
        if peripheral.getType(name) == "modem" then
            pcall(function() rednet.open(name) end)
        end
    end
end

-- tablet listener thread
local tabletThread = function()
    pcall(function() tablet.startRednetListener(state, logic, state_mod) end)
end

-- event loop: monitor clicks and keyboard
local eventLoop = function()
    while true do
        local ev = {os.pullEvent()}
        local eventName = ev[1]

        if eventName == "monitor_touch" then
            local side, x, y = ev[2], ev[3], ev[4]
            local si, ti = ui.mapClickToTask(monitor, state, x, y)
            if si and ti then
                local ok, msg = logic.performTask(state, si, ti)
                if ok then state_mod.saveState(state); ui.draw(monitor, state); if useTerm then print(msg) end end
            else
                -- left ascii area clicked -> do nothing for now
            end

        elseif eventName == "mouse_click" and useTerm then
            -- mouse_click: button, x, y
            local button, x, y = ev[2], ev[3], ev[4]
            local si, ti = ui.mapClickToTask(monitor, state, x, y)
            if si and ti then
                local ok, msg = logic.performTask(state, si, ti)
                if ok then state_mod.saveState(state); ui.draw(monitor, state); print(msg) end
            end

        elseif eventName == "key" then
            local key = ev[2]
            local name = keys.getName(key)
            if name == "l" then
                if state.lang == "de" then state.lang = "en" elseif state.lang == "en" then state.lang = "pl" else state.lang = "de" end
                state_mod.saveState(state); ui.draw(monitor, state); print("Language: "..state.lang)
            elseif name == "r" then
                state = state_mod.resetState(); ui.draw(monitor, state); print("State reset.")
            end

        elseif eventName == "term_resize" then
            ui.draw(monitor, state)
        end
    end
end

-- run both in parallel
parallel.waitForAny(function() tabletThread() end, function() eventLoop() end)

-- save on exit (shouldn't normally reach)
state_mod.saveState(state)
print("Tower stopped.")
