EnemyBullet = {}
EnemyBullet.__index = EnemyBullet

-- syntax equivalent to "MyClass.new = function..."
function EnemyBullet.new(sprite, x, y, angle)
  self = setmetatable({}, EnemyBullet)
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

function EnemyBullet.checkIfInside(self, locX,locY)
    if (locX < 160 and locX > -160) and (locY < 120 and locY > -120) then
        return true
    else
        self.layer:removeProp(self.prop)
        return false
    end
end

function EnemyBullet.checkCollision(self)
  local obj = self.partition:propForPoint( self.prop:getLoc() )
  if obj then
    self.partition:removeProp(obj)
    ---------------
    self.layer:removeProp(self.prop)
  end
end

function EnemyBullet.bulletMovement(self, x, y)
  nx = x + math.cos(math.rad(self.angle)) * self.speed
  ny = y + math.sin(math.rad(self.angle)) * self.speed
  return nx, ny
end


function EnemyBullet.startThread (self)
  
  function self.prop:moveEnemyBullet(parent)
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
  self.prop.thread:run(self.prop.moveEnemyBullet, self.prop, self)
end