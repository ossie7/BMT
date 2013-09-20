shipUpgradesList = {}
lastTappedShipUpgrade = 1

function SetupShipUpgradesList()
  local upgradeOffset = 90
  
  local upgradeItem1 = UpgradeItem.new(sprite)
  upgradeItem1:SetName("Phaser Cannon Mk I")
  upgradeItem1:SetResources(20, 2000)
  upgradeItem1:SetRequiredTime(0)
  upgradeItem1:UpdateLocation(0, 10)
  upgradeItem1:UpdateScale(0.5)
  table.insert(shipUpgradesList, upgradeItem1)
  
  local upgradeItem2 = UpgradeItem.new(sprite)
  upgradeItem2:SetName("Phaser Cannon Mk II")
  upgradeItem2:SetResources(500, 5000)
  upgradeItem2:SetRequiredTime(2)
  upgradeItem2:UpdateLocation(1 * upgradeOffset, 10)
  table.insert(shipUpgradesList, upgradeItem2)
  
  local upgradeItem3 = UpgradeItem.new(sprite)
  upgradeItem3:SetName("Phaser Cannon Mk III")
  upgradeItem3:SetResources(1000, 10000)
  upgradeItem3:SetRequiredTime(4)
  upgradeItem3:UpdateLocation(2 * upgradeOffset, 10)
  table.insert(shipUpgradesList, upgradeItem3)
end

function UpdateShipUpgradesPositions(deltaX, deltaY, index)
  if index ~= lastTappedShipUpgrade then
    for i = 1, table.getn(shipUpgradesList), 1 do
      local upgrade = shipUpgradesList[i]
      upgrade:UpdateLocation(deltaX, deltaY)
      
      if i == index then
        upgrade:UpdateScale(0.5)
      elseif i == lastTappedShipUpgrade then
        upgrade:UpdateScale(-0.5)
      end
    end
  end
  
  lastTappedShipUpgrade = index
end
