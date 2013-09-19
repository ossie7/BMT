UpgradeItem = {}
UpgradeItem.__index = UpgradeItem

-- syntax equivalent to "MyClass.new = function..."
function UpgradeItem.new()
  self = setmetatable({}, UpgradeItem)
  
  self.name = ""
  self.resourceLeftFaction = 0
  self.resourceRightFaction = 0
  self.requiredTime = 0
  self.prop = MOAIProp2D.new()
  self.prop:setDeck(sprite)
  self.prop:setLoc(x, y)
  self.prop:setBlendMode( MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA )
  upgradePartition:insertProp(self.prop)
  
  return self
end

function UpgradeItem:SetName(name)
  self.name = name
end

function UpgradeItem:GetName()
  return self.name
end

function UpgradeItem:SetResources(resourceLeftFaction, resourceRightFaction)
  self.resourceLeftFaction = resourceLeftFaction
  self.resourceRightFaction = resourceRightFaction
end

function UpgradeItem:GetResourcesLeftFaction()
  return self.resourceLeftFaction
end

function UpgradeItem:GetResourcesRightFaction()
  return self.resourceRightFaction
end

function UpgradeItem:SetRequiredTime(requiredTime)
  self.requiredTime = requiredTime
end

function UpgradeItem:GetRequiredTime()
  return self.requiredTime
end

function UpgradeItem:UpdateLocation(deltaX, deltaY)
  local x, y = self.prop:getLoc()
  self.prop:setLoc(x + deltaX, y + deltaY)
end

function UpgradeItem:GetProp()
  return self.prop
end
