shipUpgradesList = {}
stationUpgradesList = {}
currentUpgradesList = {}
upgradeType = ""--"ship" or "station"
lastTappedUpgrade = 1
upgradeOffset = 90

function CreateShipUpgradesList()
  local upgradeItem1 = UpgradeItem.new("Strider", 0, 0, 0)
  local upgradeItem2 = UpgradeItem.new("Fixer", 50, 500, 2)
  local upgradeItem3 = UpgradeItem.new("Shocker", 100, 1000, 4)
  
  table.insert(shipUpgradesList, upgradeItem1)
  table.insert(shipUpgradesList, upgradeItem2)
  table.insert(shipUpgradesList, upgradeItem3)
  
  if table.getn(userdata.shipUpgrades) > 0 then
    for i = 1, table.getn(userdata.shipUpgrades), 1 do
      shipUpgradesList[i]:Build(userdata.shipUpgrades[i])
    end
  end
end

function CreateStationUpgradesList()
  local upgradeItem1 = UpgradeItem.new("Station Hull", 100, 1000, 5)
  local upgradeItem2 = UpgradeItem.new("Live Support", 200, 2000, 7)
  local upgradeItem3 = UpgradeItem.new("Embassasy", 300, 3000, 9)
  
  table.insert(stationUpgradesList, upgradeItem1)
  table.insert(stationUpgradesList, upgradeItem2)
  table.insert(stationUpgradesList, upgradeItem3)
  
  if table.getn(userdata.stationUpgrades) > 0 then
    for i = 1, table.getn(userdata.stationUpgrades), 1 do
      stationUpgradesList[i]:Build(userdata.stationUpgrades[i])
    end
  end
end

CreateShipUpgradesList()
CreateStationUpgradesList()