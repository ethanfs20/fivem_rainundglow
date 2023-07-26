local isRainbowUnderglowEnabled = false
local interval = 100
local option = "off"

local function GenerateRainbowColor()
    local time = GetGameTimer() / interval
    local r = math.floor(math.sin(time) * 127 + 128)
    local g = math.floor(math.sin(time + 2) * 127 + 128)
    local b = math.floor(math.sin(time + 4) * 127 + 128)
    return r, g, b
end

local function GenerateRandomColor()
    return math.random(0, 255), math.random(0, 255), math.random(0, 255)
end

local function TurnOffNeonLights(vehicle)
    for i = 0, 3 do SetVehicleNeonLightEnabled(vehicle, i, false) end
    return
end

local function ToggleRainbowUnderglow()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)

    if vehicle ~= 0 then
        Citizen.CreateThread(function()
            while isRainbowUnderglowEnabled do
                Citizen.Wait(0)
                if option == "pulse" then
                    local rFront, gFront, bFront = GenerateRandomColor()
                    local rBack, gBack, bBack = GenerateRandomColor()
                    local rLeft, gLeft, bLeft = GenerateRandomColor()
                    local rRight, gRight, bRight = GenerateRandomColor()

                    SetVehicleNeonLightsColour(vehicle, rFront, gFront, bFront)
                    SetVehicleNeonLightsColour(vehicle, rBack, gBack, bBack)
                    SetVehicleNeonLightsColour(vehicle, rLeft, gLeft, bLeft)
                    SetVehicleNeonLightsColour(vehicle, rRight, gRight, bRight)

                    SetVehicleNeonLightEnabled(vehicle, 0, true)
                    SetVehicleNeonLightEnabled(vehicle, 1, true)
                    SetVehicleNeonLightEnabled(vehicle, 2, true)
                    SetVehicleNeonLightEnabled(vehicle, 3, true)
                    Citizen.Wait(interval / 2)
                    TurnOffNeonLights(vehicle)
                    Citizen.Wait(interval * 2)
                elseif option == "strobe" then
                    local rFront, gFront, bFront = GenerateRandomColor()
                    local rBack, gBack, bBack = GenerateRandomColor()
                    local rLeft, gLeft, bLeft = GenerateRandomColor()
                    local rRight, gRight, bRight = GenerateRandomColor()

                    SetVehicleNeonLightsColour(vehicle, rFront, gFront, bFront)
                    SetVehicleNeonLightsColour(vehicle, rBack, gBack, bBack)
                    SetVehicleNeonLightsColour(vehicle, rLeft, gLeft, bLeft)
                    SetVehicleNeonLightsColour(vehicle, rRight, gRight, bRight)

                    SetVehicleNeonLightEnabled(vehicle, 0, true)
                    SetVehicleNeonLightEnabled(vehicle, 1, true)
                    SetVehicleNeonLightEnabled(vehicle, 2, true)
                    SetVehicleNeonLightEnabled(vehicle, 3, true)
                    Citizen.Wait(interval / 2)
                    TurnOffNeonLights(vehicle)
                    Citizen.Wait(interval / 2)
                elseif option == "smooth" then
                    local rFront, gFront, bFront = GenerateRainbowColor()
                    local rBack, gBack, bBack = GenerateRainbowColor()
                    local rLeft, gLeft, bLeft = GenerateRainbowColor()
                    local rRight, gRight, bRight = GenerateRainbowColor()

                    SetVehicleNeonLightsColour(vehicle, rFront, gFront, bFront)
                    SetVehicleNeonLightsColour(vehicle, rBack, gBack, bBack)
                    SetVehicleNeonLightsColour(vehicle, rLeft, gLeft, bLeft)
                    SetVehicleNeonLightsColour(vehicle, rRight, gRight, bRight)

                    SetVehicleNeonLightEnabled(vehicle, 0, true)
                    SetVehicleNeonLightEnabled(vehicle, 1, true)
                    SetVehicleNeonLightEnabled(vehicle, 2, true)
                    SetVehicleNeonLightEnabled(vehicle, 3, true)
                elseif option == "off" then
                    isRainbowUnderglowEnabled = false
                    TurnOffNeonLights(vehicle)
                    break
                end
            end
        end)
    end
end

-- Initial command to enable the underglow.
RegisterCommand("rainbow", function(source, args)
    local optionNew = args[1]
    -- Check if the player input is a valid option.
    if optionNew ~= "pulse" and optionNew ~= "strobe" and optionNew ~= "smooth" and
        optionNew ~= "off" then
        TriggerEvent('chat:addMessage', {
            color = {255, 0, 0},
            multiline = true,
            args = {
                "Rainbow Underglow",
                "Invalid option. Please use /rainbow pulse, /rainbow strobe, /rainbow smooth, or /rainbow off."
            }
        })
        return
    end
    option = optionNew
    TurnOffNeonLights(vehicle)
    if not isRainbowUnderglowEnabled then
        isRainbowUnderglowEnabled = true
        ToggleRainbowUnderglow()
    elseif optionNew == "off" then
        isRainbowUnderglowEnabled = false
    end
end)

-- Second thread to check if the player is in a vehicle or not. This is needed because it will break the script if the player has the underglow enabled and then exits the vehicle.
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000) -- check every 5 seconds because we do not need this running every frame. (Performance)
        if not IsPedInAnyVehicle(PlayerPedId(), false) then
            isRainbowUnderglowEnabled = false
            option = "off"
        end
    end
end)

