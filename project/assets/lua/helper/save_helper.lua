-- Persistent data: user-based data that must be recorded
userdata_path = (MOAIEnvironment.documentDirectory or "./") .. "/userdata.lua"
userdata_f = loadfile(userdata_path) or nil
userdata = {}

-- Save the contents of the user_data, for eternity ..
function save_userdata()
  local serializer = MOAISerializer.new()
  
  for i = 1, table.getn(shipUpgradesList), 1 do
    userdata.shipUpgrades[i] = shipUpgradesList[i]:IsBuild()
  end
  
  for i = 1, table.getn(stationUpgradesList), 1 do
    userdata.stationUpgrades[i] = stationUpgradesList[i]:IsBuild()
  end
  
  serializer:serialize(userdata)
  local userdata_Str = serializer:exportToString()
  local userdata_file = io.open(userdata_path, 'wb')
  
  print("Writing User Data: ", userdata_path)
  -- attempt to save the file ..
  if (userdata_file ~= nil) then
    userdata_file:write(userdata_Str)
    userdata_file:close()
  end
  print("User Data Written")
  
end

function SetupNewUserdata()
  userdata.shipUpgrades = {}
  userdata.stationUpgrades = {}
  userdata.warzone = 5
  userdata.metal = 0
  userdata.plasma = 0
  userdata.mission = "chased"
  userdata.turn = 0
  userdata.stationBuild = false
  userdata.isFirstTime = true
  userdata.daysBuild = 0
  userdata.showEngineer = false
  userdata.firstTimeStation = true
  userdata.seenFirstOverlay = false
  userdata.seenShipUpgradesOverlay = false
  
end

function clearUpgrades()
  
  for i = 1, table.getn(shipUpgradesList), 1 do
    shipUpgradesList[i]:Build(false)
  end
  
  for i = 1, table.getn(stationUpgradesList), 1 do
    stationUpgradesList[i]:Build(false)
  end
  
end


-- At the beginning of your application, get the persisted data:
if (userdata_f ~= nil) then
  userdata = userdata_f()
  if(userdata.shipUpgrades == nil) then userdata.shipUpgrades = {} end
  if(userdata.stationUpgrades == nil) then userdata.stationUpgrades = {} end
  if(userdata.warzone == nil) then userdata.warzone = 5 end
  if(userdata.metal == nil) then userdata.metal = 0 end
  if(userdata.plasma == nil) then userdata.plasma = 0 end
  if(userdata.mission == nil) then userdata.mission = "chased" end
  if(userdata.turn == nil) then userdata.turn = 0 end
  if(userdata.stationBuild == nil) then userdata.stationBuild = false end
  if(userdata.isFirstTime == nil) then userdata.isFirstTime = true end
  if(userdata.daysBuild == nil) then userdata.daysBuild = 0 end
  if(userdata.showEngineer == nil) then userdata.showEngineer = false end
  if(userdata.firstTimeStation == nil) then userdata.firstTimeStation = true end
  if(userdata.seenFirstOverlay == nil) then userdata.seenFirstOverlay = false end
  if(userdata.seenShipUpgradesOverlay == nil) then userdata.seenShipUpgradesOverlay = false end
else
  SetupNewUserdata()
end
