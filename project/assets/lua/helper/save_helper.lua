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
  userdata.warzone = 5
  userdata.metal = 0
  userdata.tech = 0
end

-- At the beginning of your application, get the persisted data:
if (userdata_f ~= nil) then
  userdata = userdata_f()
else
  SetupNewUserdata()
end
