function BuildShipUpgrade()
  local upgrade = shipUpgradesList[lastTappedShipUpgrade]
  
  if EnoughResources(upgrade) then
    local metal = upgrade:GetRequiredMetal()
    local tech = upgrade:GetRequiredTech()
    
    userdata.metal = userdata.metal - metal
    userdata.tech = userdata.tech - tech
    
    upgrade:Build(true)
  end
  
  save_userdata()
  
  return upgrade
end

function EnoughResources(upgrade)
  local metal = upgrade:GetRequiredMetal()
  local tech = upgrade:GetRequiredTech()
  
  if userdata.metal >= metal and userdata.tech >= tech then
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
