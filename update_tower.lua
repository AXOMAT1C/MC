-- Liste aller Tower-Dateien
local files = {
    "tower_core.lua",
    "tower_state.lua",
    "tower_logic.lua",
    "tower_ui.lua",
    "tower_addon_tablet.lua",
    "text_size.lua",
    "tower_visual.lua",}

-- GitHub-Raw-Basis-URL
local baseURL = "https://raw.githubusercontent.com/AXOMAT1C/MC/main/"

-- Abfrage starten
print("Willst du alle Tower-Dateien updaten? (j/n)")
local answer = read():lower()

if answer == "j" then
    for i, file in ipairs(files) do
        local url = baseURL .. file
        print(string.format("[%d/%d] Lade %s ...", i, #files, file))
        shell.run("wget", url, file)  -- Datei wird überschrieben
    end
    print("✅ Alle Dateien wurden aktualisiert!")
    print("Starte tower_core.lua ...")
    sleep(1)
    shell.run("tower_core.lua")
else
    print("Abgebrochen.")
end
