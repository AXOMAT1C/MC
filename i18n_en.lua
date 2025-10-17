local T = {}

T.title = "Tower Management"
T.floor = "Floor"
T.button_plus = "+"
T.button_minus = "-"

T.floors = {"Roof","Wood","Farms","Item","Defense","Storage","EN/ME"}
T.tasks = {
    Roof = {"Build Teleporter","Install Glass Roof","Decorative Roof"},
    Wood = {"Collect Logs","Plant Trees","Set Decorations"},
    Farms = {"Plant Crops","Care Animals","Bee Keeping"},
    Item = {"AE2 Terminals","Crafting Station","Build Conveyors"},
    Defense = {"Build Turrets","Build Walls"},
    Storage = {"Setup Drawers","Buffers","Intermediate Storage"},
    ["EN/ME"] = {"Build Powah Generator","Setup AE2 Core","Setup ME Storage"}
}

return T
