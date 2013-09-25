shipUpgradesList = {}
lastTappedShipUpgrade = 1
upgradeOffset = 90

function SetupShipUpgradesList()
  ugunsprite  = ucs("resources/weapons.png",     -16,  -16, 16,  16) --Gun
  local upgradeItem1 = UpgradeItem.new(ugunsprite, "Phaser Cannon Mk I", 20, 2000, 0)
  upgradeItem1:SetLocation(0, 10)
  upgradeItem1:SetScale(3)
  table.insert(shipUpgradesList, upgradeItem1)
  
  local upgradeItem2 = UpgradeItem.new(ugunsprite, "Phaser Cannon Mk II", 500, 5000, 2)
  upgradeItem2:SetLocation(1 * upgradeOffset, 10)
  table.insert(shipUpgradesList, upgradeItem2)
  
  local upgradeItem3 = UpgradeItem.new(ugunsprite, "Phaser Cannon Mk III", 1000, 10000, 4)
  upgradeItem3:SetLocation(2 * upgradeOffset, 10)
  table.insert(shipUpgradesList, upgradeItem3)
end

function LoadShipUpgradesList()
  for i = 1, table.getn(shipUpgradesList), 1 do
    shipUpgradesList[i]:SetLocation((i - 1) * upgradeOffset, 10)
    upgradePartition:insertProp(shipUpgradesList[i]:GetProp())
    
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
      
      if i == index then
        upgrade:UpdateScale(1)
      elseif i == lastTappedShipUpgrade then
        upgrade:UpdateScale(-1)
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

function ucs(path, x1, y1, x2, y2) -- Create sprite
  local texture = MOAIImage.new()
  texture:load(path)
  local sprite = MOAIGfxQuad2D.new()
  sprite:setTexture(texture)
  sprite:setRect(x1, y1, x2, y2)
  return sprite
end

SetupShipUpgradesList()