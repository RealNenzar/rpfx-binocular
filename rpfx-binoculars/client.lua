-- Globale und lokale Variablen für den Fernglas-/Kamera-Modus
IsUsingBinoculars = false
IsUsingWeazelCamera = false
IsUsingLegacyCamera = false

local currentFov = 40.0
local cam
local scaleform_bin
local rotationCounter = 0
local lastZoomTime = 0
local initialCamRotZ = 0
local cumulativeRotation = 0
local cumulativeRotationX = 0
local initialPlayerHeading = 0
local currentDeviceConfig = nil -- Aktuelle Geräte-Konfiguration
local currentDeviceType = nil -- "binoculars", "weazel", "legacy"

-- Funktion zum Aufräumen und Zurücksetzen des Fernglas-/Kamera-Modus
local function CleanupDevice()
    ClearPedTasks(PlayerPedId())
    ClearTimecycleModifier()
    RenderScriptCams(false, false, 0, true, false)
    if scaleform_bin then
        SetScaleformMovieAsNoLongerNeeded(scaleform_bin)
        scaleform_bin = nil
    end
    if cam then
        DestroyCam(cam, false)
        cam = nil
    end
    FreezeEntityPosition(PlayerPedId(), false)
    exports['arcore-core']:setIngameOverlayActiveExport(true)
    DisplayRadar(true)
    currentDeviceConfig = nil
    currentDeviceType = nil
end

-- Alias für Rückwärtskompatibilität
local function CleanupBinoculars()
    CleanupDevice()
end

-- Zeichnet das Kamera-Overlay für Videokameras (wenn keine Scaleform verwendet wird)
local function DrawCameraOverlay(config)
    if not config or config.useScaleform then return end
    
    -- REC-Indikator oben links (roter Punkt + Text)
    -- Zeichne roten blinkenden Kreis mit Sprite
    local blinkAlpha = 255
    if math.floor(GetGameTimer() / 500) % 2 == 0 then
        blinkAlpha = 255
    else
        blinkAlpha = 100
    end
    
    -- Lade die Textur für den Kreis
    if not HasStreamedTextureDictLoaded("mpleaderboard") then
        RequestStreamedTextureDict("mpleaderboard", true)
    end
    -- Zeichne roten Kreis (Sprite)
    DrawSprite("mpleaderboard", "leaderboard_circle", 0.024, 0.035, 0.012, 0.02, 0.0, 255, 0, 0, blinkAlpha)
    
    -- REC Text daneben
    SetTextFont(4)
    SetTextScale(0.5, 0.5)
    SetTextColour(255, 255, 255, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString("REC")
    DrawText(0.035, 0.02)
    
    -- Kamera-Label oben rechts
    if config.overlayLabel and config.overlayLabel ~= "" then
        SetTextFont(4)
        SetTextScale(0.4, 0.4)
        SetTextColour(255, 255, 255, 200)
        SetTextDropShadow()
        SetTextOutline()
        SetTextRightJustify(true)
        SetTextWrap(0.0, 0.98)
        SetTextEntry("STRING")
        AddTextComponentString(config.overlayLabel)
        DrawText(0.98, 0.02)
    end
    
    -- Zeitstempel unten rechts
    if config.showTimestamp then
        local hour = GetClockHours()
        local minute = GetClockMinutes()
        local second = GetClockSeconds()
        local timestamp = string.format("%02d:%02d:%02d", hour, minute, second)
        
        SetTextFont(4)
        SetTextScale(0.35, 0.35)
        SetTextColour(255, 255, 255, 200)
        SetTextDropShadow()
        SetTextOutline()
        SetTextRightJustify(true)
        SetTextWrap(0.0, 0.98)
        SetTextEntry("STRING")
        AddTextComponentString(timestamp)
        DrawText(0.98, 0.95)
    end
end

-- Hauptfunktion zum Aktivieren oder Deaktivieren der Geräte (Fernglas/Kameras)
function UseDevice(deviceType, config)
    -- Setze die aktuelle Konfiguration
    currentDeviceConfig = config
    currentDeviceType = deviceType
    
    -- Verhindere Nutzung im Fahrzeug, wenn nicht konfiguriert erlaubt
    if not config.allowInVehicle and IsPedSittingInAnyVehicle(PlayerPedId()) then
        return
    end
    -- Zusätzliche Prüfung: Keine Nutzung beim Fahren
    if IsPedSittingInAnyVehicle(PlayerPedId()) then
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        if GetPedInVehicleSeat(vehicle, -1) == PlayerPedId() and GetEntitySpeed(vehicle) > 0.1 then
            return
        end
    end
    -- Prüfe, ob bereits eine andere Aktion läuft
    if IsInActionWithErrorMessage({ ['IsUsingBinoculars'] = true, ['IsUsingWeazelCamera'] = true, ['IsUsingLegacyCamera'] = true }) then
        return
    end
    
    -- Setze den entsprechenden Status
    local isActive = false
    if deviceType == "binoculars" then
        IsUsingBinoculars = not IsUsingBinoculars
        isActive = IsUsingBinoculars
    elseif deviceType == "weazel" then
        IsUsingWeazelCamera = not IsUsingWeazelCamera
        isActive = IsUsingWeazelCamera
    elseif deviceType == "legacy" then
        IsUsingLegacyCamera = not IsUsingLegacyCamera
        isActive = IsUsingLegacyCamera
    end

    if isActive then
        -- Setze FOV auf Startwert
        currentFov = 40.0
        
        -- Wende Timecycle-Modifier an, wenn konfiguriert
        if config.timecycle and config.timecycle ~= "" then
            SetTimecycleModifier(config.timecycle)
            SetTimecycleModifierStrength(config.timecycleStrength or 0.5)
        end
        
        -- Friere Spieler ein, wenn Bewegung nicht erlaubt
        if not config.allowMovement then
            TaskStandStill(PlayerPedId(), -1)
            FreezeEntityPosition(PlayerPedId(), true)
        else
            -- Bewegung erlaubt - stelle sicher, dass der Spieler nicht eingefroren ist
            FreezeEntityPosition(PlayerPedId(), false)
        end
        DisplayRadar(false)
        
        -- Lade die Scaleform, wenn aktiviert
        local scaleformLoaded = false
        if config.useScaleform and config.scaleform and config.scaleform ~= "" then
            scaleform_bin = RequestScaleformMovie(config.scaleform)
            local timeout = 0
            while not HasScaleformMovieLoaded(scaleform_bin) and timeout < 100 do
                Wait(10)
                timeout = timeout + 1
            end
            scaleformLoaded = HasScaleformMovieLoaded(scaleform_bin)
        end

        -- Erstelle und konfiguriere die Kamera
        cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)
        AttachCamToPedBone(cam, PlayerPedId(), 12844, 0.0, 0.5, 0.0, true)
        SetCamRot(cam, 0.0, 0.0, GetEntityHeading(PlayerPedId()))
        initialCamRotZ = GetEntityHeading(PlayerPedId())
        initialPlayerHeading = GetEntityHeading(PlayerPedId())
        cumulativeRotation = 0
        cumulativeRotationX = 0
        SetCamFov(cam, currentFov)
        RenderScriptCams(true, false, 0, true, false)
        
        if scaleformLoaded then
            PushScaleformMovieFunction(scaleform_bin, "SET_CAM_LOGO")
            PushScaleformMovieFunctionParameterInt(0)
            PopScaleformMovieFunctionVoid()
        end

        -- Hauptschleife während Gerät aktiv
        local function isDeviceActive()
            if deviceType == "binoculars" then return IsUsingBinoculars
            elseif deviceType == "weazel" then return IsUsingWeazelCamera
            elseif deviceType == "legacy" then return IsUsingLegacyCamera
            end
            return false
        end
        
        while isDeviceActive() and not IsEntityDead(PlayerPedId()) and (config.allowInVehicle or not IsPedSittingInAnyVehicle(PlayerPedId())) do

            currentFov = HandleZoomAndCheckRotationWithConfig(cam, currentFov, config)

            -- Drehe Spieler gelegentlich zur Kamera (nur zu Fuß und nur wenn Bewegung nicht erlaubt)
            rotationCounter = rotationCounter + 1
            if rotationCounter % 5 == 0 and GetVehiclePedIsIn(PlayerPedId(), false) == 0 then
                if not config.allowMovement then
                    -- Nur zur Kamera drehen wenn Bewegung nicht erlaubt ist
                    local camRot = GetCamRot(cam, 2)
                    SetEntityHeading(PlayerPedId(), camRot.z)
                end
            end
            
            -- Bewegungssteuerung basierend auf allowMovement
            if not IsPedSittingInAnyVehicle(PlayerPedId()) then
                if config.allowMovement then
                    -- Bewegung erlaubt - Spieler kann sich frei bewegen
                    FreezeEntityPosition(PlayerPedId(), false)
                else
                    -- Bewegung nicht erlaubt - Spieler einfrieren und WASD blockieren
                    FreezeEntityPosition(PlayerPedId(), true)
                    DisableControlAction(0, 32, true) -- W (Vorwärts)
                    DisableControlAction(0, 33, true) -- S (Rückwärts)
                    DisableControlAction(0, 34, true) -- A (Links)
                    DisableControlAction(0, 35, true) -- D (Rechts)
                end
            end
            
            -- Deaktiviere alle störenden Controls
            DisableControlAction(0, 25, true)
            DisablePlayerFiring(PlayerPedId(), true)
            DisableControlAction(0, 12, true)
            DisableControlAction(0, 13, true)
            DisableControlAction(0, 14, true)
            DisableControlAction(0, 15, true)
            DisableControlAction(0, 37, true)
            HideHudComponentThisFrame(19)
            BlockWeaponWheelThisFrame()
            DisableControlAction(0, 81, true)
            DisableControlAction(0, 82, true)
            DisplayRadar(false)
            exports['arcore-core']:setIngameOverlayActiveExport(false)

            -- Zeichne Overlay
            if scaleformLoaded then
                DrawScaleformMovieFullscreen(scaleform_bin, 255, 255, 255, 255)
            else
                DrawCameraOverlay(config)
            end
            Wait(1)
        end
    end

    -- Setze alles zurück
    if deviceType == "binoculars" then
        IsUsingBinoculars = false
    elseif deviceType == "weazel" then
        IsUsingWeazelCamera = false
    elseif deviceType == "legacy" then
        IsUsingLegacyCamera = false
    end

    -- Stelle die ursprüngliche Spieler-Heading wieder her (nicht im Fahrzeug)
    if GetVehiclePedIsIn(PlayerPedId(), false) == 0 then
        SetEntityHeading(PlayerPedId(), initialPlayerHeading)
    end

    CleanupDevice()
end

-- Wrapper-Funktion für Fernglas (Rückwärtskompatibilität)
function UseBinocular()
    UseDevice("binoculars", Config.Binoculars)
end

-- Funktion für Weazel News Kamera
function UseWeazelCamera()
    UseDevice("weazel", Config.WeazelNewsCamera)
end

-- Funktion für Legacy Records Kamera
function UseLegacyCamera()
    UseDevice("legacy", Config.LegacyRecordsCamera)
end

-- Event-Handler für Item-Wechsel in der Hand
local itemInHandCallback = function(slot)
    if slot then
        local itemName = slot.item.item_name
        
        -- Fernglas
        if itemName == Config.Binoculars.itemName then
            if not IsUsingBinoculars then
                UseBinocular()
            end
        -- Weazel News Videokamera
        elseif itemName == Config.WeazelNewsCamera.itemName then
            if not IsUsingWeazelCamera then
                UseWeazelCamera()
            end
        -- Legacy Records Videokamera
        elseif itemName == Config.LegacyRecordsCamera.itemName then
            if not IsUsingLegacyCamera then
                UseLegacyCamera()
            end
        else
            -- Anderes Item - alle Geräte deaktivieren
            if IsUsingBinoculars then
                IsUsingBinoculars = false
                CleanupDevice()
            end
            if IsUsingWeazelCamera then
                IsUsingWeazelCamera = false
                CleanupDevice()
            end
            if IsUsingLegacyCamera then
                IsUsingLegacyCamera = false
                CleanupDevice()
            end
        end
    else
        -- Kein Item in der Hand - alle Geräte deaktivieren
        if IsUsingBinoculars then
            IsUsingBinoculars = false
            CleanupDevice()
        end
        if IsUsingWeazelCamera then
            IsUsingWeazelCamera = false
            CleanupDevice()
        end
        if IsUsingLegacyCamera then
            IsUsingLegacyCamera = false
            CleanupDevice()
        end
    end
end

-- Thread zum Blockieren des Aussteigens aus dem Fahrzeug, während ein Gerät aktiv ist
Citizen.CreateThread(function()
    while true do
        Wait(0)
        local isAnyDeviceActive = IsUsingBinoculars or IsUsingWeazelCamera or IsUsingLegacyCamera
        if isAnyDeviceActive then
            local ped = PlayerPedId()
            
            -- Im Fahrzeug: Aussteigen blockieren
            if IsPedSittingInAnyVehicle(ped) then
                DisableControlAction(0, 47, true)
            end
            
            -- Nur stillstehen wenn Bewegung NICHT erlaubt ist
            if currentDeviceConfig and not currentDeviceConfig.allowMovement and not IsPedSittingInAnyVehicle(ped) then
                TaskStandStill(ped, 100)
            end
        end
    end
end)

-- Thread zum Registrieren des Callbacks, sobald das Core-Modul verfügbar ist
Citizen.CreateThread(function()
    while not exports['arcore-core'] do
        Citizen.Wait(100)
    end
    local success = exports['arcore-core']:onItemInHandChanged(itemInHandCallback)
end)

-- Cleanup beim Stoppen der Ressource
AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        CleanupDevice()
        exports['arcore-core']:removeCallback('itemInHandChanged', itemInHandCallback)
    end
end)

-- Verarbeitet Mausbewegungen für Kamerarotation (veraltet, wird in HandleZoomAndCheckRotation verwendet)
function CheckInputRotation(cam, zoomvalue)
	local rightAxisX = GetDisabledControlNormal(0, 220)
	local rightAxisY = GetDisabledControlNormal(0, 221)
	local rotation = GetCamRot(cam, 2)
	if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
		new_z = rotation.z + rightAxisX*-1.0*(Config.speed_ud)*(zoomvalue+0.1)
		new_x = math.max(math.min(20.0, rotation.x + rightAxisY*-1.0*(Config.speed_lr)*(zoomvalue+0.1)), -89.5)
		SetCamRot(cam, new_x, 0.0, new_z, 2)
	end
end

-- Handhabt Zoom-Funktionalität, unterscheidet zwischen zu Fuß und im Fahrzeug
function HandleZoom(cam)
	local lPed = GetPlayerPed(-1)
	if not ( IsPedSittingInAnyVehicle( lPed ) ) then
		-- Zoom mit Mausrad zu Fuß
		if IsControlJustPressed(0,241) then
			fov = math.max(fov - Config.zoomspeed, Config.fov_min)
		end
		if IsControlJustPressed(0,242) then
			fov = math.min(fov + Config.zoomspeed, Config.fov_max)
		end
		local current_fov = GetCamFov(cam)
		if math.abs(fov-current_fov) < 0.1 then
			fov = current_fov
		end
		SetCamFov(cam, current_fov + (fov - current_fov)*0.05)
	else
		-- Zoom mit Tasten im Fahrzeug
		if IsControlJustPressed(0,17) then
			fov = math.max(fov - Config.zoomspeed, Config.fov_min)
		end
		if IsControlJustPressed(0,16) then
			fov = math.min(fov + Config.zoomspeed, Config.fov_max)
		end
		local current_fov = GetCamFov(cam)
		if math.abs(fov-current_fov) < 0.1 then
			fov = current_fov
		end
		SetCamFov(cam, current_fov + (fov - current_fov)*0.05)
	end
end

-- Kombinierte Funktion für Zoom und Rotation mit Konfiguration
function HandleZoomAndCheckRotationWithConfig(cam, fov, config)
    local lPed = PlayerPedId()
    local zoomvalue = (1.0 / (config.fov_max - config.fov_min)) * (fov - config.fov_min)
    -- Zoom mit Verzögerung, um Abstürze zu vermeiden
    if IsControlJustPressed(0, 241) and GetGameTimer() - lastZoomTime > 100 then
        fov = math.max(fov - config.zoomspeed, config.fov_min)
        lastZoomTime = GetGameTimer()
    end
    if IsControlJustPressed(0, 242) and GetGameTimer() - lastZoomTime > 100 then
        fov = math.min(fov + config.zoomspeed, config.fov_max)
        lastZoomTime = GetGameTimer()
    end
    local current_fov = GetCamFov(cam)
    if math.abs(fov - current_fov) < 0.1 then
        fov = current_fov
    end
    SetCamFov(cam, current_fov + (fov - current_fov) * 0.05)

    -- Verarbeite Mausrotation
    local rightAxisX = GetDisabledControlNormal(0, 220)
    local rightAxisY = GetDisabledControlNormal(0, 221)
    local rotation = GetCamRot(cam, 2)
    if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
        local rotationMultiplier = 1.0
        if IsPedSittingInAnyVehicle(PlayerPedId()) then
            -- Begrenze Rotation im Fahrzeug
            local deltaZ = rightAxisX * -1.0 * (config.speed_ud) * (zoomvalue + 0.1) * rotationMultiplier
            if cumulativeRotation + deltaZ > 90 then
                deltaZ = 90 - cumulativeRotation
            elseif cumulativeRotation + deltaZ < -90 then
                deltaZ = -90 - cumulativeRotation
            end
            cumulativeRotation = cumulativeRotation + deltaZ
            new_z = initialCamRotZ + cumulativeRotation
            local deltaX = rightAxisY * -1.0 * (config.speed_lr) * (zoomvalue + 0.1) * rotationMultiplier
            if cumulativeRotationX + deltaX > 30 then
                deltaX = 30 - cumulativeRotationX
            elseif cumulativeRotationX + deltaX < -30 then
                deltaX = -30 - cumulativeRotationX
            end
            cumulativeRotationX = cumulativeRotationX + deltaX
            new_x = cumulativeRotationX
        elseif config.allowMovement then
            -- Zu Fuß mit Bewegung erlaubt: Begrenze Rotation relativ zur Spielerrichtung
            local playerHeading = GetEntityHeading(PlayerPedId())
            
            -- Berechne neue absolute Rotation
            local newRotZ = rotation.z + rightAxisX * -1.0 * (config.speed_ud) * (zoomvalue + 0.1) * rotationMultiplier
            
            -- Berechne die Differenz zur Spielerrichtung (normalisiert auf -180 bis 180)
            local diff = newRotZ - playerHeading
            while diff > 180 do diff = diff - 360 end
            while diff < -180 do diff = diff + 360 end
            
            -- Begrenze die Differenz auf ±90°
            if diff > 90 then
                newRotZ = playerHeading + 90
            elseif diff < -90 then
                newRotZ = playerHeading - 90
            end
            
            new_z = newRotZ
            new_x = math.max(math.min(45.0, rotation.x + rightAxisY * -1.0 * (config.speed_lr) * (zoomvalue + 0.1) * rotationMultiplier), -60.0)
        else
            -- Zu Fuß ohne Bewegung: Freie Rotation (Spieler dreht sich mit)
            new_z = rotation.z + rightAxisX * -1.0 * (config.speed_ud) * (zoomvalue + 0.1) * rotationMultiplier
            new_x = math.max(math.min(20.0, rotation.x + rightAxisY * -1.0 * (config.speed_lr) * (zoomvalue + 0.1) * rotationMultiplier), -89.5)
        end
        SetCamRot(cam, new_x, 0.0, new_z, 2)
    end

    return fov
end

-- Kombinierte Funktion für Zoom und Rotation mit zusätzlichen Limits im Fahrzeug (Legacy/Rückwärtskompatibilität)
function HandleZoomAndCheckRotation(cam, fov)
    -- Nutze Binoculars-Config als Standard für Rückwärtskompatibilität
    return HandleZoomAndCheckRotationWithConfig(cam, fov, Config.Binoculars)
end

-- Prüft, ob der Spieler bereits in einer anderen Aktion ist
function IsInActionWithErrorMessage(actions)
    for action, _ in pairs(actions) do
        if _G[action] then
            return true
        end
    end
    return false
end