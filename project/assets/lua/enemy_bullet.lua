EnemyBullet = {}
EnemyBullet.__index = EnemyBullet

-- syntax equivalent to "MyClass.new = function..."
function EnemyBullet.new(sprite, x, y, angle)
  self = setmetatable({}, EnemyBullet)
  self.prop = MOAIProp2D.new()
  self.partition = ebpartition
  self.layer = eblayer
  self.angle = angle
  self.speed = 1
  self.prop:setDeck(sprite)
  self.prop:setLoc(x, y)
  self.prop:setRot(angle)
  self.prop:setBlendMode( MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA )
  self.prop.owner = self
  return self
end

function EnemyBullet.checkIfInside(self, locX,locY)
  if (locX < 160 and locX > -160) and (locY < 90 and locY > -90) then
    return true
  else
    self.layer:removeProp(self.prop)
    self.prop.thread:stop()
    return false
  end
end

function EnemyBullet.bulletMovement(self, x, y)
  nx = x + math.cos(math.rad(self.angle)) * self.speed
  ny = y + math.sin(math.rad(self.angle)) * self.speed
  return nx, ny
end

function EnemyBullet.reflect(self)
  eblayer:removeProp(self.prop)
  ebrpartition:insertProp(self.prop)
  self.layer = ebrlayer
  self.angle = self.angle+180
end

function EnemyBullet.startThread (self)
  
  function self.prop:moveEnemyBullet(parent)
    local locX,locY = self:getLoc()
    
    while parent:checkIfInside(locX,locY) do
      if(gamestate == "pause" or gamestate == "upgrading") then
        break
      end
      --checkBulletCollision()
      locX,locY = parent:bulletMovement(locX, locY)
      self:setLoc(locX,locY)
      
      coroutine.yield()
    end
    self.thread:stop()
  end

  self.prop.thread = MOAICoroutine.new()
  self.prop.thread:run(self.prop.moveEnemyBullet, self.prop, self)
end