-- tower_logic.lua
-- Task activation, progress increments, status, reset individual tasks
local M = {}

-- toggle task; returns (ok,message)
function M.performTask(state, sectionIndex, taskIndex)
    local floor = state.floors[state.currentFloor]
    if not floor then return false, "Floor not found" end
    local section = floor.sections[sectionIndex]
    if not section then return false, "Section not found" end
    local task = section.tasks[taskIndex]
    if not task then return false, "Task not found" end

    task.active = not task.active

    if task.active then
        -- activation increases progress by a configurable delta
        local delta = 10
        task.progress = math.min(100, (task.progress or 0) + delta)
        -- auto-stop at 100
        if task.progress >= 100 then task.active = false end
    end

    local status = string.format("%s: %d%% (active=%s)", task.id, task.progress, tostring(task.active))
    return true, status
end

function M.resetTask(state, sectionIndex, taskIndex)
    local floor = state.floors[state.currentFloor]
    local section = floor and floor.sections[sectionIndex]
    local task = section and section.tasks[taskIndex]
    if task then
        task.progress = 0
        task.active = false
        return true
    end
    return false
end

function M.summary(state)
    local parts = {}
    local floor = state.floors[state.currentFloor]
    for si, section in ipairs(floor.sections) do
        for ti, task in ipairs(section.tasks) do
            table.insert(parts, string.format("%s|%d|%d|%s|%d|%s", floor.name, si, ti, task.id, task.progress or 0, tostring(task.active)))
        end
    end
    return table.concat(parts, ";")
end

return M
