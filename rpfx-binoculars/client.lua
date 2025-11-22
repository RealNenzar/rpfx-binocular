-- Globale und lokale Variablen für den Fernglas-Modus
IsUsingBinoculars = false

local fov = 40.0
local cam
local scaleform_bin
local rotationCounter = 0
local lastZoomTime = 0
local initialCamRotZ = 0
local cumulativeRotation = 0
local cumulativeRotationX = 0

-- Funktion zum Aufräumen und Zurücksetzen des Fernglas-Modus
local function CleanupBinoculars()
    ClearPedTasks(PlayerPedId())
    ClearTimecycleModifier()
    RenderScriptCams(false, false, 0, true, false)
    SetScaleformMovieAsNoLongerNeeded(scaleform_bin)
    DestroyCam(cam, false)
    FreezeEntityPosition(PlayerPedId(), false)
    exports['rpfx-core']:setIngameOverlayActiveExport(true)
    DisplayRadar(true)
end

-- Hauptfunktion zum Aktivieren oder Deaktivieren der Ferngläser
function UseBinocular()
    -- Verhindere Nutzung im Fahrzeug, wenn nicht konfiguriert erlaubt
    if not Config.allowInVehicle and IsPedSittingInAnyVehicle(PlayerPedId()) then
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
    if IsInActionWithErrorMessage({ ['IsUsingBinoculars'] = true }) then
        return
    end
    IsUsingBinoculars = not IsUsingBinoculars

    if IsUsingBinoculars then
        -- Wende Timecycle-Modifier für Fernglas-Effekt an
        SetTimecycleModifier(Config.timecycle)
        SetTimecycleModifierStrength(Config.timecycleStrength)
        -- Friere Spieler ein, wenn Bewegung nicht erlaubt
        FreezeEntityPosition(PlayerPedId(), not Config.allowMovement)
        if not Config.allowMovement then
            TaskStandStill(PlayerPedId(), -1)
        end
        DisplayRadar(false)
        -- Lade das Binocular-Scaleform
        scaleform_bin = RequestScaleformMovie("BINOCULARS")
        local timeout = 0
        while not HasScaleformMovieLoaded(scaleform_bin) and timeout < 100 do
            Wait(10)
            timeout = timeout + 1
        end
        local scaleformLoaded = HasScaleformMovieLoaded(scaleform_bin)

        -- Erstelle und konfiguriere die Kamera für die Fernglas-Sicht
        cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)

        AttachCamToPedBone(cam, PlayerPedId(), 12844, 0.0, 0.5, 0.0, true)
        SetCamRot(cam, 0.0, 0.0, GetEntityHeading(PlayerPedId()))
        initialCamRotZ = GetEntityHeading(PlayerPedId())
        cumulativeRotation = 0
        cumulativeRotationX = 0
        SetCamFov(cam, fov)
        RenderScriptCams(true, false, 0, true, false)
        if scaleformLoaded then
            PushScaleformMovieFunction(scaleform_bin, "SET_CAM_LOGO")
            PushScaleformMovieFunctionParameterInt(0) -- Kein Logo
            PopScaleformMovieFunctionVoid()
        end

        -- Hauptschleife während Fernglas aktiv
        while IsUsingBinoculars and not IsEntityDead(PlayerPedId()) and (Config.allowInVehicle or not IsPedSittingInAnyVehicle(PlayerPedId())) do

            fov = HandleZoomAndCheckRotation(cam, fov)

            -- Drehe Spieler gelegentlich zur Kamera, um Abstürze zu vermeiden
            rotationCounter = rotationCounter + 1
            if rotationCounter % 5 == 0 and not IsPedSittingInAnyVehicle(PlayerPedId()) then
                local camRot = GetCamRot(cam, 2)
                SetEntityHeading(PlayerPedId(), camRot.z)
            end
            -- Deaktiviere alle störenden Controls während der Nutzung
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
            exports['rpfx-core']:setIngameOverlayActiveExport(false)

            if scaleformLoaded then
                DrawScaleformMovieFullscreen(scaleform_bin, 255, 255, 255, 255)
            end
            Wait(1)
        end
    end

    -- Setze alles zurück
    IsUsingBinoculars = false

    CleanupBinoculars()
end

-- Event-Handler für Item-Wechsel in der Hand
local itemInHandCallback = function(slot)
    if slot and slot.item.item_name == "Fernglas" then
        if not IsUsingBinoculars then
            UseBinocular()
        end
    else
        if IsUsingBinoculars then
            IsUsingBinoculars = false
            CleanupBinoculars()
        end
    end
end

-- Thread zum Registrieren des Callbacks, sobald das Core-Modul verfügbar ist
Citizen.CreateThread(function()
    while not exports['rpfx-core'] do
        Citizen.Wait(100)
    end
    local success = exports['rpfx-core']:onItemInHandChanged(itemInHandCallback)
end)

-- Cleanup beim Stoppen der Ressource
AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        CleanupBinoculars()
        exports['rpfx-core']:removeCallback('itemInHandChanged', itemInHandCallback)
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

-- Kombinierte Funktion für Zoom und Rotation mit zusätzlichen Limits im Fahrzeug
function HandleZoomAndCheckRotation(cam, fov)
    local lPed = PlayerPedId()
    local zoomvalue = (1.0 / (Config.fov_max - Config.fov_min)) * (fov - Config.fov_min)
    -- Zoom mit Verzögerung, um Abstürze zu vermeiden
    if IsControlJustPressed(0, 241) and GetGameTimer() - lastZoomTime > 100 then
        fov = math.max(fov - Config.zoomspeed, Config.fov_min)
        lastZoomTime = GetGameTimer()
    end
    if IsControlJustPressed(0, 242) and GetGameTimer() - lastZoomTime > 100 then
        fov = math.min(fov + Config.zoomspeed, Config.fov_max)
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
            local deltaZ = rightAxisX * -1.0 * (Config.speed_ud) * (zoomvalue + 0.1) * rotationMultiplier
            if cumulativeRotation + deltaZ > 90 then
                deltaZ = 90 - cumulativeRotation
            elseif cumulativeRotation + deltaZ < -90 then
                deltaZ = -90 - cumulativeRotation
            end
            cumulativeRotation = cumulativeRotation + deltaZ
            new_z = initialCamRotZ + cumulativeRotation
            local deltaX = rightAxisY * -1.0 * (Config.speed_lr) * (zoomvalue + 0.1) * rotationMultiplier
            if cumulativeRotationX + deltaX > 30 then
                deltaX = 30 - cumulativeRotationX
            elseif cumulativeRotationX + deltaX < -30 then
                deltaX = -30 - cumulativeRotationX
            end
            cumulativeRotationX = cumulativeRotationX + deltaX
            new_x = cumulativeRotationX
        else
            new_z = rotation.z + rightAxisX * -1.0 * (Config.speed_ud) * (zoomvalue + 0.1) * rotationMultiplier
            new_x = math.max(math.min(20.0, rotation.x + rightAxisY * -1.0 * (Config.speed_lr) * (zoomvalue + 0.1) * rotationMultiplier), -89.5)
        end
        SetCamRot(cam, new_x, 0.0, new_z, 2)
    end

    return fov
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