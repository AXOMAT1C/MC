local T = {}

T.floors = {
    "ROOF",
    "WOOD",
    "FARMS",
    "ITEM",
    "DEFENSE",
    "STORAGE",
    "EN_ME"
}

T.tasks = {
    ["ROOF"] = {"Build Teleporter", "Set End Access", "Build Decorative Roof"},
    ["WOOD"] = {"Place Logs", "Plant Trees", "Place Decorative Blocks"},
    ["FARMS"] = {"Plant 1", "Plant 2", "Harvest Crops"},
    ["ITEM"] = {"Create Conveyors", "Place AE2 IO-Terminals", "Build Crafting Station"},
    ["DEFENSE"] = {"Place Turrets", "Build Walls"},
    ["STORAGE"] = {"Setup Drawers", "Place Functional Storage"},
    ["EN_ME"] = {"Build Powah Generator", "Setup AE2 Core", "Place ME Storage Cells"}
}

T.button_plus = "+"
T.button_minus = "-"
return T
