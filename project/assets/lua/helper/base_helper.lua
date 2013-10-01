function LoadShipUpgradesList()
  for i = 1, table.getn(shipUpgradesList), 1 do
    shipUpgradesList[i]:Load(gunsprite)
    shipUpgradesList[i]:SetLocation((i - 1) * upgradeOffset, 10)
    if i == 1 then
      shipUpgradesList[i]:SetScale(3)
    else
      shipUpgradesList[i]:SetScale(2)
    end
  end
  
  lastTappedUpgrade = 1
  currentUpgradesList = shipUpgradesList
end

function UpdateShipUpgradesPositions(deltaX, deltaY, index)
  if index ~= lastTappedUpgrade then
    for i = 1, table.getn(currentUpgradesList), 1 do
      local upgrade = currentUpgradesList[i]
      upgrade:UpdateLocation(deltaX, deltaY)
      
      if i == lastTappedUpgrade then
        upgrade:UpdateScale(-1)
      end
      
      if i == index then
        upgrade:UpdateScale(1)
      end
    end
  end
  
  lastTappedUpgrade = index
end

function UpdateShipUpgradesPositionsBySwipe(deltaX, deltaY)
  for i = 1, table.getn(shipUpgradesList), 1 do
    local upgrade = shipUpgradesList[i]
    
    local x, y = upgrade:GetProp():getLoc()
    x = x + deltaX
    y = y + deltaY
    
    upgrade:SetLocation(x, y)
  end
end

function SnapToClosestUpgrade()
  local closestIndex = 0
  local smallestDistance = 0
  
  for i = 1, table.getn(shipUpgradesList), 1 do
    local upgrade = shipUpgradesList[i]    
    local x, y = upgrade:GetProp():getLoc()
    
    if i == 1 then
      closestIndex = i
      smallestDistance = math.abs(x)
    else
      if math.abs(x) < smallestDistance then
        closestIndex = i
        smallestDistance = math.abs(x)
      end
    end
  end
  
  local closestUpgrade = shipUpgradesList[closestIndex]    
  local closestX, closestY = closestUpgrade:GetProp():getLoc()
  
  UpdateShipUpgradesPositionsBySwipe(0 - closestX, 0)
end