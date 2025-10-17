local T = {}

T.title = "Tower Management"
T.floor = "Stockwerk"
T.button_plus = "+"
T.button_minus = "-"

T.floors = {"Dach","Wood","Farms","Item","Defense","Storage","EN/ME"}
T.tasks = {
    Dach = {"Teleporter bauen","Glasdach installieren","Dekoratives Dach"},
    Wood = {"Logs sammeln","Bäume pflanzen","Dekoration setzen"},
    Farms = {"Pflanzen setzen","Tiere versorgen","Bienenhaltung"},
    Item = {"AE2 Terminals","Crafting Station","Conveyors bauen"},
    Defense = {"Türme bauen","Wände bauen"},
    Storage = {"Drawers einrichten","Buffern","Intermediate Storage"},
    ["EN/ME"] = {"Powah Generator bauen","AE2 Core aufstellen","ME Storage"}
}

return T
