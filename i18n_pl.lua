local T = {}

T.title = "Zarządzanie Wieżą"
T.floor = "Piętro"
T.button_plus = "+"
T.button_minus = "-"

T.floors = {"Dach","Drewno","Farmy","Przedmioty","Obrona","Magazyn","EN/ME"}
T.tasks = {
    Dach = {"Zbuduj Teleporter","Zainstaluj Szklany Dach","Dekoracyjny Dach"},
    Drewno = {"Zbierz Drewno","Posadź Drzewa","Ustaw Dekoracje"},
    Farmy = {"Posadź Rośliny","Opiekuj się Zwierzętami","Pszczelarstwo"},
    Przedmioty = {"Terminale AE2","Stacja Rzemieślnicza","Zbuduj Conveyor"},
    Obrona = {"Zbuduj Wieże","Zbuduj Mury"},
    Magazyn = {"Ustaw Drawers","Bufory","Magazyn Pośredni"},
    ["EN/ME"] = {"Zbuduj Generator Powah","Ustaw AE2 Core","Ustaw ME Storage"}
}

return T
