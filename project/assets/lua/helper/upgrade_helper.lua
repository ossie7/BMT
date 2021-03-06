function BuildUpgrade()
  local upgrade = currentUpgradesList[lastTappedUpgrade]
  
  if EnoughResources(upgrade) then
    local allowBuild = true
    
    if upgradeType == "station" and userdata.warzone ~= 5 then
      allowBuild = false
    end
    
    if allowBuild and upgrade:IsBuild() == false then
      local metal = upgrade:GetRequiredMetal()
      local plasma = upgrade:GetRequiredPlasma()
      
      userdata.metal = userdata.metal - metal
      userdata.plasma = userdata.plasma - plasma
      
      upgrade:Build(true)
      if(upgradeType == "station") then
        userdata.stationBuild = true
      end
      
      buySound:play()
      textboxChatBox:setString("You bought a "..upgrade.name..".")
      
      save_userdata()
    end
  end
  
  textboxMetalAmount:setString(""..userdata.metal)
  textboxEnergyAmount:setString(""..userdata.plasma)
  
  return upgrade
end

function EnoughResources(upgrade)
  local metal = upgrade:GetRequiredMetal()
  local plasma = upgrade:GetRequiredPlasma()
  
  if userdata.metal >= metal and userdata.plasma >= plasma then
    return true
  else
    return false
  end
end

function SetBuildButtonVisibility(upgrade)
  if upgrade:IsBuild() then
    propBuildButton:setVisible(false)
  else
    if EnoughResources(upgrade) then
      propBuildButton:setVisible(true)
    else
      propBuildButton:setVisible(false)
    end
  end
end

function AmountOfShipUpgradesBought()
  local amount = 0
  
  if table.getn(shipUpgradesList) > 0 then
    for i = 1, table.getn(shipUpgradesList), 1 do
      if shipUpgradesList[i]:IsBuild() then
        amount = amount + 1
      end
    end
  end
  
  return amount
end
