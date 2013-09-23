function BuildShipUpgrade()
  local upgrade = shipUpgradesList[lastTappedShipUpgrade]
  upgrade:Build(true)
  
  save_userdata()
  
  return upgrade
end
