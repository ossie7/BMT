shipUpgradesList = {}

function SetupShipUpgradesList()
  local upgradeOffset = 70
  
  local upgradeItem1 = UpgradeItem.new(sprite)
  upgradeItem1:SetName("Phaser Cannon Mk I")
  upgradeItem1:SetResources(20, 2000)
  upgradeItem1:SetRequiredTime(0)
  upgradeItem1:UpdateLocation(0, 0)
  table.insert(shipUpgradesList, upgradeItem1)
  
  local upgradeItem2 = UpgradeItem.new(sprite)
  upgradeItem2:SetName("Phaser Cannon Mk II")
  upgradeItem2:SetResources(500, 5000)
  upgradeItem2:SetRequiredTime(2)
  upgradeItem2:UpdateLocation(1 * upgradeOffset, 0)
  table.insert(shipUpgradesList, upgradeItem2)
  
  local upgradeItem3 = UpgradeItem.new(sprite)
  upgradeItem3:SetName("Phaser Cannon Mk III")
  upgradeItem3:SetResources(1000, 10000)
  upgradeItem3:SetRequiredTime(4)
  upgradeItem3:UpdateLocation(2 * upgradeOffset, 0)
  table.insert(shipUpgradesList, upgradeItem3)
end

function UpdateShipUpgradesPositions(deltaX, deltaY)
  for i = 1, table.getn(shipUpgradesList), 1 do
    local upgrade = shipUpgradesList[i]
    upgrade:UpdateLocation(deltaX, deltaY)
  end
end
