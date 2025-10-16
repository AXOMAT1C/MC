-- tower_logic.lua
local tower_state = require("tower_state")

local function performAction(floor, amount)
    local current = tower_state.getProgress(floor)
    tower_state.setProgress(floor, current + (amount or 0.1))
end

return {
    performAction = performAction
}
