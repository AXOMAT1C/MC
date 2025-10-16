-- tower_core.lua
rednet.open("back")
local tower_state = require("tower_state")
local tower_logic = require("tower_logic")

local floors = {"DACH","WOOD","FARMS","ITEM","DEFENSE","STORAGE","EN/ME"}

while true do
    for _,id in pairs(rednet.lookup("tablet") or {}) do
        rednet.send(id, {type="update", data=tower_state.getAll()})
    end
    for _,f in ipairs(floors) do
        tower_logic.performAction(f,0.01)
    end
    sleep(1)
end
