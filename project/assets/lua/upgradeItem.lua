UpgradeItem = {}
UpgradeItem.__index = UpgradeItem

-- syntax equivalent to "MyClass.new = function..."
function UpgradeItem.new(sprite, name, requiredResourceLeftFaction, requiredResourceRightFaction, requiredTime)
  self = setmetatable({}, UpgradeItem)
  
  self.name = name
  self.resourceLeftFaction = requiredResourceLeftFaction
  self.resourceRightFaction = requiredResourceRightFaction
  self.requiredTime = requiredTime
  self.prop = MOAIProp2D.new()
  self.prop:setDeck(sprite)
  self.prop:setLoc(x, y)
  self.prop:setBlendMode(MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA)
  self.prop.name = "upgradeItem"
  upgradePartition:insertProp(self.prop)
  
  return self
end

function UpgradeItem:SetName(name)
  self.name = name
end

function UpgradeItem:GetName()
  return self.name
end

function UpgradeItem:SetRequiredResources(resourceLeftFaction, resourceRightFaction)
  self.resourceLeftFaction = resourceLeftFaction
  self.resourceRightFaction = resourceRightFaction
end

function UpgradeItem:GetRequiredResourcesLeftFaction()
  return self.resourceLeftFaction
end

function UpgradeItem:GetRequiredResourcesRightFaction()
  return self.resourceRightFaction
end

function UpgradeItem:SetRequiredTime(requiredTime)
  self.requiredTime = requiredTime
end

function UpgradeItem:GetRequiredTime()
  return self.requiredTime
end

function UpgradeItem:SetLocation(x, y)
  self.prop:setLoc(x, y)
end

function UpgradeItem:SetScale(scale)
  self.prop:setScl(scale, scale)
end

function UpgradeItem:UpdateLocation(deltaX, deltaY)
  local animSpeed = 1
  self.prop:moveLoc(deltaX, deltaY, animSpeed)
end

function UpgradeItem:UpdateScale(scale)
  local animSpeed = 1
  self.prop:moveScl(scale, scale, animSpeed)
end

function UpgradeItem:GetProp()
  return self.prop
end
