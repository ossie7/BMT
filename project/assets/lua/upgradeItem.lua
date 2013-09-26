UpgradeItem = {}
UpgradeItem.__index = UpgradeItem

-- syntax equivalent to "MyClass.new = function..."
function UpgradeItem.new(sprite, name, metal, tech, requiredTime)
  self = setmetatable({}, UpgradeItem)
  
  self.name = name
  self.metal = metal
  self.tech = tech
  self.requiredTime = requiredTime
  self.build = false
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

function UpgradeItem:SetRequiredResources(metal, tech)
  self.metal = metal
  self.tech = tech
end

function UpgradeItem:GetRequiredMetal()
  return self.metal
end

function UpgradeItem:GetRequiredTech()
  return self.tech
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

function UpgradeItem:Build(build)
  self.build = build--boolean
end

function UpgradeItem:IsBuild()
  return self.build
end
