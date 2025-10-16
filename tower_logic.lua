-- tower_logic.lua
local tower_state = require("tower_state")

local function performAction(floor, amount)
    tower_state.setProgress(floor, tower_state.getProgress(floor) + (amount or 0.1))
end

return {
    performAction = performAction
}
