function BuildShipUpgrade()
  local upgrade = shipUpgradesList[lastTappedShipUpgrade]
  upgrade:Build(true)
  
  save_userdata()
  
  return upgrade
end

function SetBuildButtonVisibility(upgrade)
  print("SetBuildButtonVisibility")
  if upgrade:IsBuild() then
    propBuildButton:setVisible(false)
  else
    propBuildButton:setVisible(true)
  end
end
