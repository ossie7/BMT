shipUpgradesList = {}
lastTappedShipUpgrade = 1

function SetupShipUpgradesList()
  local upgradeOffset = 90
  
  local upgradeItem1 = UpgradeItem.new(sprite, "Phaser Cannon Mk I", 20, 2000, 0)
  upgradeItem1:SetLocation(0, 10)
  upgradeItem1:SetScale(1.5)
  table.insert(shipUpgradesList, upgradeItem1)
  
  local upgradeItem2 = UpgradeItem.new(sprite, "Phaser Cannon Mk II", 500, 5000, 2)
  upgradeItem2:SetLocation(1 * upgradeOffset, 10)
  table.insert(shipUpgradesList, upgradeItem2)
  
  local upgradeItem3 = UpgradeItem.new(sprite, "Phaser Cannon Mk III", 1000, 10000, 4)
  upgradeItem3:SetLocation(2 * upgradeOffset, 10)
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
