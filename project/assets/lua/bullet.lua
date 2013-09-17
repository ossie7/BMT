Bullet = {}
Bullet.__index = Bullet

-- syntax equivalent to "MyClass.new = function..."
function Bullet.new(sprite, layer, x, y, partition)
  self = setmetatable({}, Bullet)
  self.prop = MOAIProp2D.new()
  self.partition = partition
  if(sprite ~= nil and layer ~= nil and x ~= nil and y ~= nil) then
    self.layer = layer
    self.prop:setDeck(sprite)
    self.prop:setLoc(x, y)
    self.prop:setBlendMode( MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA )
  end
  return self
end

function Bullet.setDeck(self, sprite)
  self.prop:setDeck(sprite)
end

function Bullet.setLoc(self, x, y)
  self.prop:setLoc(x, y)
end

function Bullet.checkIfInside(self, locX,locY)
    if (locX < 160 and locX > -160) and (locY < 120 and locY > -120) then
        return true
    else
        self.layer:removeProp(self.prop)
        return false
    end
end

function Bullet.checkCollision(self)
  local obj = self.partition:propForPoint( self.prop:getLoc() )
  if obj then
    self.partition:removeProp(obj)
    coins = coins + 1
    textboxGameMode:setString("Coins = "..coins)
    self.layer:removeProp(self.prop)
  end
end

function Bullet.startThread (self)
  
  function self.prop:moveBullet(layer, parent)
    local locX,locY = self:getLoc()
    
    while parent:checkIfInside(locX,locY) do
      parent:checkCollision()
      locX,locY = self:getLoc()
      self:setLoc(locX+5,locY)
      coroutine.yield()
    end
    self.thread:stop()
  end

  self.prop.thread = MOAICoroutine.new()
  self.prop.thread:run(self.prop.moveBullet, self.prop, self.layer, self)
end