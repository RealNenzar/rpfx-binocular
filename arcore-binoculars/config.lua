-- Konfiguration für den Fernglas-Modus
_G.Config = {
    -- =====================================================
    -- FERNGLAS EINSTELLUNGEN
    -- =====================================================
    Binoculars = {
        itemName = "Fernglas", -- Item-Name im Inventar
        
        -- Einstellungen für Zoom
        fov_max = 70.0, -- Maximale Field of View (größerer Wert bedeutet weniger Zoom)
        fov_min = 5.0, -- Minimale Field of View (kleinerer Wert bedeutet mehr Zoom)
        zoomspeed = 10.0, -- Geschwindigkeit, mit der gezoomt wird

        -- Einstellungen für Kamerabewegung
        speed_lr = 8.0, -- Geschwindigkeit der horizontalen Kamerabewegung (links-rechts)
        speed_ud = 8.0, -- Geschwindigkeit der vertikalen Kamerabewegung (hoch-runter)

        -- Bewegungseinstellungen
        allowMovement = false, -- Erlaubt dem Spieler, sich mit WASD zu bewegen

        -- Fahrzeugeinstellungen
        allowInVehicle = true, -- Erlaubt die Nutzung im Fahrzeug

        -- Timecycle-Einstellungen
        timecycle = "glasses_green", -- Visueller Effekt
        timecycleStrength = 0.5, -- Stärke des visuellen Effekts
        
        -- Scaleform-Einstellungen
        useScaleform = true, -- Scaleform-Overlay aktivieren
        scaleform = "BINOCULARS", -- Name der Scaleform
    },
    
    -- =====================================================
    -- WEAZEL NEWS VIDEOKAMERA EINSTELLUNGEN
    -- =====================================================
    WeazelNewsCamera = {
        itemName = "Weazel News Videokamera TEST", -- Item-Name im Inventar
        
        -- Einstellungen für Zoom
        fov_max = 70.0, -- Maximale Field of View (größerer Wert bedeutet weniger Zoom)
        fov_min = 5.0, -- Minimale Field of View (kleinerer Wert bedeutet mehr Zoom)
        zoomspeed = 10.0, -- Geschwindigkeit, mit der gezoomt wird

        -- Einstellungen für Kamerabewegung
        speed_lr = 8.0, -- Geschwindigkeit der horizontalen Kamerabewegung (links-rechts)
        speed_ud = 8.0, -- Geschwindigkeit der vertikalen Kamerabewegung (hoch-runter)

        -- Bewegungseinstellungen
        allowMovement = true, -- Erlaubt dem Spieler, sich mit WASD zu bewegen

        -- Fahrzeugeinstellungen
        allowInVehicle = false, -- Erlaubt die Nutzung im Fahrzeug

        -- Timecycle-Einstellungen
        timecycle = "", -- Visueller Effekt (leer = kein Effekt, "default" für Standard)
        timecycleStrength = 0.0, -- Stärke des visuellen Effekts
        
        -- Scaleform-Einstellungen
        useScaleform = false, -- Scaleform-Overlay aktivieren (false = eigenes Overlay)
        scaleform = "", -- Name der Scaleform (leer = kein Scaleform)
        
        -- Kamera-Overlay Einstellungen (wenn useScaleform = false)
        overlayText = "~s~REC", -- Text der oben links angezeigt wird (mit Farbcodes)
        overlayLabel = "WEAZEL NEWS", -- Label der Kamera
        showTimestamp = true, -- Zeitstempel anzeigen
    },
    
    -- =====================================================
    -- LEGACY RECORDS VIDEOKAMERA EINSTELLUNGEN
    -- =====================================================
    LegacyRecordsCamera = {
        itemName = "Legacy Records Videokamera TEST", -- Item-Name im Inventar
        
        -- Einstellungen für Zoom
        fov_max = 70.0, -- Maximale Field of View (größerer Wert bedeutet weniger Zoom)
        fov_min = 5.0, -- Minimale Field of View (kleinerer Wert bedeutet mehr Zoom)
        zoomspeed = 10.0, -- Geschwindigkeit, mit der gezoomt wird

        -- Einstellungen für Kamerabewegung
        speed_lr = 8.0, -- Geschwindigkeit der horizontalen Kamerabewegung (links-rechts)
        speed_ud = 8.0, -- Geschwindigkeit der vertikalen Kamerabewegung (hoch-runter)

        -- Bewegungseinstellungen
        allowMovement = true, -- Erlaubt dem Spieler, sich mit WASD zu bewegen

        -- Fahrzeugeinstellungen
        allowInVehicle = false, -- Erlaubt die Nutzung im Fahrzeug

        -- Timecycle-Einstellungen
        timecycle = "", -- Visueller Effekt (leer = kein Effekt)
        timecycleStrength = 0.0, -- Stärke des visuellen Effekts
        
        -- Scaleform-Einstellungen
        useScaleform = false, -- Scaleform-Overlay aktivieren (false = eigenes Overlay)
        scaleform = "", -- Name der Scaleform (leer = kein Scaleform)
        
        -- Kamera-Overlay Einstellungen (wenn useScaleform = false)
        overlayText = "~s~REC", -- Text der oben links angezeigt wird (mit Farbcodes)
        overlayLabel = "LEGACY RECORDS", -- Label der Kamera
        showTimestamp = true, -- Zeitstempel anzeigen
    },
}