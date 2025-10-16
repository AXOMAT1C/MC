-- init.lua
-- Startet automatisch das Tablet Addon

-- Optional: Monitor initialisieren
local monitor = peripheral.wrap("top")
if monitor then
    monitor.clear()
    monitor.setBackgroundColor(colors.black)
    monitor.setTextColor(colors.white)
end

-- Rednet öffnen, falls noch nicht offen
if not rednet.isOpen("back") then
    rednet.open("back")
end

-- Script starten
shell.run("tower_addon_tablet.lua")
