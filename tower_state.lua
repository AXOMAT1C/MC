-- tower_state.lua
-- Laden / Speichern / Reset des Spielstands
local M = {}
local SAVE_FILE = "tower_state.dat"

local function defaultState()
    return {
        lang = "de", -- "de", "en", "pl"
        currentFloor = 1,
        -- Übersichtsstruktur, Tasks repräsentieren deine Bereiche (id, title, progress 0-100, active)
        floors = {
            {
                name = "AXOMAT1C CORE",
                sections = {
                    {
                        name = "PROJEKTE",
                        tasks = {
                            { id="DACH", title_de="DACH/SKY", title_en="DACH/SKY", title_pl="DACH/SKY", progress=0, active=false },
                            { id="WOOD", title_de="WOOD", title_en="WOOD", title_pl="WOOD", progress=0, active=false },
                            { id="FARMS", title_de="FARMS", title_en="FARMS", title_pl="FARMS", progress=0, active=false },
                            { id="ITEM", title_de="ITEM", title_en="ITEM", title_pl="ITEM", progress=0, active=false },
                            { id="DEFENSE", title_de="DEFENSE", title_en="DEFENSE", title_pl="DEFENSE", progress=0, active=false },
                            { id="STORAGE", title_de="STORAGE", title_en="STORAGE", title_pl="STORAGE", progress=0, active=false },
                            { id="EN_ME", title_de="EN / ME", title_en="EN / ME", title_pl="EN / ME", progress=0, active=false },
                        }
                    }
                }
            }
        }
    }
end

function M.loadState()
    if fs.exists(SAVE_FILE) then
        local f = fs.open(SAVE_FILE, "r")
        local data = f.readAll()
        f.close()
        local ok, st = pcall(textutils.unserialize, data)
        if ok and type(st) == "table" then
            return st
        end
    end
    local s = defaultState()
    M.saveState(s)
    return s
end

function M.saveState(state)
    local f = fs.open(SAVE_FILE, "w")
    f.write(textutils.serialize(state))
    f.close()
end

function M.resetState()
    local s = defaultState()
    M.saveState(s)
    return s
end

return M
