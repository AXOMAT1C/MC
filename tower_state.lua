-- tower_state.lua
local state = {}
local progress = {}

local function setProgress(floor, value)
    progress[floor] = math.min(math.max(value,0),1)
end

local function getProgress(floor)
    return progress[floor] or 0
end

local function getAll()
    local copy = {}
    for k,v in pairs(progress) do copy[k]=v end
    return copy
end

return {
    setProgress = setProgress,
    getProgress = getProgress,
    getAll = getAll
}
