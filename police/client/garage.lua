
local buttons = {}

function load_garage()
	for k in ipairs (buttons) do
		buttons [k] = nil
	end

	for k, data in pairs(vehicles) do
		if config.useCopWhitelist then
			if dept == k then
				for k, v in pairs(data) do
					buttons[#buttons+1] = {name = tostring(v.name), func = "SpawnerVeh", params = tostring(v.model)}
				end
			end
		else
			if dept == 1 then
				for k, v in pairs(data) do
					buttons[#buttons+1] = {name = tostring(v.name), func = "SpawnerVeh", params = tostring(v.model)}
				end
			end
		end
	end
end

function SpawnerVeh(hash)
	if IsPedInAnyVehicle(PlayerPedId(), false) then
		currentVehicle = GetVehiclePedIsIn(PlayerPedId(), false)
		DeleteEntity(currentVehicle)
	end

	local car = GetHashKey(hash)
	local playerPed = PlayerPedId()

	RequestModel(car)
	while not HasModelLoaded(car) do
		Citizen.Wait(0)
	end

	local playerCoords = GetEntityCoords(playerPed)
	local playerHeading = GetEntityHeading(playerPed)
	
	policevehicle = CreateVehicle(car, playerCoords, 90.0, true, false)
	SetVehicleEngineOn(policevehicle, true, true, true)	
	SetVehicleMod(policevehicle, 11, 2)
	SetVehicleMod(policevehicle, 12, 2)
	SetVehicleMod(policevehicle, 13, 2)

	SetEntityHeading(policevehicle, (playerHeading+160)%360)
	SetVehicleEnginePowerMultiplier(policevehicle, 25.0)
	SetVehicleOnGroundProperly(policevehicle)
	SetVehicleHasBeenOwnedByPlayer(policevehicle,true)

	SetVehRadioStation(policevehicle, "OFF")	

	local netid = NetworkGetNetworkIdFromEntity(policevehicle)
	SetNetworkIdCanMigrate(netid, true)
	NetworkRegisterEntityAsNetworked(VehToNet(policevehicle))

	TaskWarpPedIntoVehicle(playerPed, policevehicle, -1)
	SetEntityInvincible(policevehicle, false)	
end

function OpenGarage()
	CloseMenu()
	SendNUIMessage({
		title = i18n.translate("garage_global_title"),
		subtitle = GetLabelText("VEX_NMB"),
		buttons = buttons,
		action = "setAndOpen"
	})
	
	anyMenuOpen.menuName = "garage"
	anyMenuOpen.isActive = true
end