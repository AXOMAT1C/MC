-- tower_addon_tablet.lua
-- Rednet listener for remote tablets/clients
local M = {}

-- Ensure modem open (tries to open any modem peripheral)
local function ensureRednetOpen()
    if not rednet then return false end
    local opened = false
    if peripheral and peripheral.getNames then
        for _, name in pairs(peripheral.getNames()) do
            if peripheral.getType(name) == "modem" then
                pcall(function() rednet.open(name) end)
                opened = true
            end
        end
    end
    return opened
end

-- start listener; runs in its own thread (parallel)
-- Commands:
-- GET_SUMMARY -> returns compact summary (logic.summary)
-- GET_STATE -> returns serialized state
-- TOGGLE:si:ti -> toggles a task
-- RESET_ALL -> resets state (dangerous)
function M.startRednetListener(state, logic, state_mod)
    if not ensureRednetOpen() then
        print("tower_addon_tablet: kein Modem offen. Rednet disabled.")
        return
    end

    while true do
        local id, msg = rednet.receive(2) -- 2s timeout to allow loop checks
        if id and msg then
            local s = tostring(msg)
            if s == "GET_SUMMARY" then
                rednet.send(id, logic.summary(state))
            elseif s == "GET_STATE" then
                rednet.send(id, textutils.serialize(state))
            elseif string.sub(s,1,7) == "TOGGLE:" then
                local parts = {}
                for part in string.gmatch(s, "([^:]+)") do table.insert(parts, part) end
                local si = tonumber(parts[2]); local ti = tonumber(parts[3])
                if si and ti then
                    logic.performTask(state, si, ti)
                    state_mod.saveState(state)
                    rednet.send(id, "OK")
                else
                    rednet.send(id, "ERR_BAD_IDX")
                end
            elseif s == "RESET_ALL" then
                state = state_mod.resetState()
                rednet.send(id, "OK_RESET")
            else
                rednet.send(id, "ERR_UNKNOWN_CMD")
            end
        else
            os.sleep(0.02)
        end
    end
end

return M
