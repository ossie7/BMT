Bullet = {}
Bullet.__index = Bullet

-- syntax equivalent to "MyClass.new = function..."
function Bullet.new(sprite, layer, x, y, partition, angle)
  self = setmetatable({}, Bullet)
  self.prop = MOAIProp2D.new()
  self.partition = partition
  self.layer = layer
  self.angle = angle
  self.speed = 5
  self.prop:setDeck(sprite)
  self.prop:setLoc(x, y)
  self.prop:setRot(angle)
  self.prop:setBlendMode( MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA )
  return self
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

function Bullet.bulletMovement(self, x, y)
  nx = x + math.cos(math.rad(self.angle)) * self.speed
  ny = y + math.sin(math.rad(self.angle)) * self.speed
  return nx, ny
end


function Bullet.startThread (self)
  
  function self.prop:moveBullet(layer, parent)
    local locX,locY = self:getLoc()
    
    while parent:checkIfInside(locX,locY) do
      parent:checkCollision()
      locX,locY = parent:bulletMovement(locX, locY)
      self:setLoc(locX,locY)
      coroutine.yield()
    end
    self.thread:stop()
  end

  self.prop.thread = MOAICoroutine.new()
  self.prop.thread:run(self.prop.moveBullet, self.prop, self.layer, self)
end