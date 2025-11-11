-- Konfiguration für den Fernglas-Modus
_G.Config = {
    -- Einstellungen für Zoom
    fov_max = 70.0, -- Maximale Field of View (größerer Wert bedeutet weniger Zoom)
    fov_min = 5.0, -- Minimale Field of View (kleinerer Wert bedeutet mehr Zoom)
    zoomspeed = 10.0, -- Geschwindigkeit, mit der gezoomt wird

    -- Einstellungen für Kamerabewegung
    speed_lr = 8.0, -- Geschwindigkeit der horizontalen Kamerabewegung (links-rechts)
    speed_ud = 8.0, -- Geschwindigkeit der vertikalen Kamerabewegung (hoch-runter)

    -- Bewegungseinstellungen
    allowMovement = false, -- Erlaubt dem Spieler, sich mit WASD zu bewegen, während das Fernglas benutzt wird

    -- Fahrzeugeinstellungen
    allowInVehicle = true, -- Erlaubt die Nutzung des Fernglases im Fahrzeug

    -- Timecycle-Einstellungen
    timecycle = "glasses_green", -- Visueller Effekt für das Fernglas
    timecycleStrength = 0.5 -- Stärke des visuellen Effekts
}