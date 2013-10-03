function LoadUpgradesList()
  if upgradeType == "ship" then
    currentUpgradesList = shipUpgradesList
  elseif upgradeType == "station" then
    currentUpgradesList = stationUpgradesList
  end
  
  for i = 1, table.getn(currentUpgradesList), 1 do
    currentUpgradesList[i]:AddToLayer(upgradeLayer)
    currentUpgradesList[i]:SetLocation((i - 1) * upgradeOffset, 5)
    if i == 1 then
      if upgradeType == "ship" then
        currentUpgradesList[i]:SetScale(2)
      elseif upgradeType == "station" then
        currentUpgradesList[i]:SetScale(1)
      end
    else
      if upgradeType == "ship" then
        currentUpgradesList[i]:SetScale(1.5)
      elseif upgradeType == "station" then
        currentUpgradesList[i]:SetScale(0.5)
      end
    end
  end
  
  lastTappedUpgrade = 1
end

function UpdateUpgradesPositions(deltaX, deltaY, index)
  if index ~= lastTappedUpgrade then
    for i = 1, table.getn(currentUpgradesList), 1 do
      local upgrade = currentUpgradesList[i]
      upgrade:UpdateLocation(deltaX, deltaY)
      
      if i == lastTappedUpgrade then
        if upgradeType == "ship" then
          upgrade:UpdateScale(-0.5)
        elseif upgradeType == "station" then
          upgrade:UpdateScale(-0.5)
        end
      end
      
      if i == index then
        if upgradeType == "ship" then
          upgrade:UpdateScale(0.5)
        elseif upgradeType == "station" then
          upgrade:UpdateScale(0.5)
        end
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