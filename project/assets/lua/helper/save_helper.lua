-- Persistent data: user-based data that must be recorded
userdata_path = (MOAIEnvironment.documentDirectory or "./") .. "/userdata.lua"
userdata_f = loadfile(userdata_path) or nil
userdata = {}
print(MOAIEnvironment.documentDirectory)
-- Save the contents of the user_data, for eternity ..
function save_userdata()
  serializer = MOAISerializer.new()
  serializer:serialize(userdata)
  userdata_Str = serializer:exportToString()

  print("Writing User Data: ", userdata_path)
  userdata_file = io.open(userdata_path, 'wb')

  -- attempt to save the file ..
  if (userdata_file ~= nil) then
    userdata_file:write(userdata_Str)
    userdata_file:close()
  end
end

-- At the beginning of your application, get the persisted data:
if (userdata_f ~= nil) then
  userdata = userdata_f()
end
