shipUpgradesList = {}
lastTappedShipUpgrade = 1
upgradeOffset = 90

function CreateShipUpgradesList()
  local upgradeItem1 = UpgradeItem.new("Phaser Cannon Mk I", 20, 2000, 0)
  local upgradeItem2 = UpgradeItem.new("Phaser Cannon Mk II", 500, 5000, 2)
  local upgradeItem3 = UpgradeItem.new("Phaser Cannon Mk III", 1000, 10000, 4)
  
  table.insert(shipUpgradesList, upgradeItem1)
  table.insert(shipUpgradesList, upgradeItem2)
  table.insert(shipUpgradesList, upgradeItem3)
  
  if table.getn(userdata.shipUpgrades) > 0 then
    for i = 1, table.getn(userdata.shipUpgrades), 1 do
      shipUpgradesList[i]:Build(userdata.shipUpgrades[i])
    end
  end
end

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
end

function UpdateShipUpgradesPositions(deltaX, deltaY, index)
  if index ~= lastTappedShipUpgrade then
    for i = 1, table.getn(shipUpgradesList), 1 do
      local upgrade = shipUpgradesList[i]
      upgrade:UpdateLocation(deltaX, deltaY)
      
      if i == lastTappedShipUpgrade then
        upgrade:UpdateScale(-1)
      end
      
      if i == index then
        upgrade:UpdateScale(1)
      end
    end
  end
  
  lastTappedShipUpgrade = index
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

CreateShipUpgradesList()