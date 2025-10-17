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
    ["DACH"] = {"Zbuduj teleporter", "Ustaw End Access", "Zbuduj dekoracyjny dach"},
    ["WOOD"] = {"Umiesc klocki", "Zasadz drzewa", "Umiesc bloki dekoracyjne"},
    ["FARMS"] = {"Zasadz roslina1", "Zasadz roslina2", "Zbierz plony"},
    ["ITEM"] = {"Stworz przenosniki", "Umiesc AE2 IO-Terminals", "Zbuduj Crafting Station"},
    ["DEFENSE"] = {"Umiesc wiezyczki", "Zbuduj mury"},
    ["STORAGE"] = {"Skonfiguruj Drawers", "Umiesc Functional Storage"},
    ["EN_ME"] = {"Zbuduj Powah Generator", "Skonfiguruj AE2 Core", "Umiesc ME Storage Cells"}
}

T.button_plus = "+"
T.button_minus = "-"
return T
