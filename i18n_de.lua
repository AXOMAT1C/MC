local T = {}

T.floors = {
    "DACH",
    "WOOD",
    "FARMS",
    "ITEM",
    "DEFENSE",
    "STORAGE",
    "EN_ME"
}

T.tasks = {
    ["DACH"] = {"Teleporter bauen", "End Access setzen", "Dekoratives Dach bauen"},
    ["WOOD"] = {"Logs platzieren", "Baeume pflanzen", "Dekobloecke setzen"},
    ["FARMS"] = {"Pflanze1 setzen", "Pflanze2 setzen", "Crops ernten"},
    ["ITEM"] = {"Conveyors erstellen", "AE2 IO-Terminals setzen", "Crafting Station bauen"},
    ["DEFENSE"] = {"Turrets platzieren", "Waende bauen"},
    ["STORAGE"] = {"Drawers einrichten", "Functional Storage aufstellen"},
    ["EN_ME"] = {"Powah Generator bauen", "AE2 Core einrichten", "ME Storage Cells setzen"}
}

T.button_plus = "+"
T.button_minus = "-"
return T
