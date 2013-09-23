Enemy = {}
Enemy.__index = Enemy

-- syntax equivalent to "MyClass.new = function..."
function Enemy.new(sprite, x, y, team)
  self = setmetatable({}, Enemy)
  self.prop = MOAIProp2D.new()
  self.team = team
  self.prop:setDeck(sprite)
  self.prop:setLoc(x, y)
  self.enemyLast = clock() + math.random()
  self.enemyInterval = 1.5 + math.random()
  self.prop:setBlendMode( MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA )
  self.prop.owner = self
  self.health = 100
  return self
end


function Enemy.startThread (self)
  
  function self.prop:moveEnemy(parent)
    while true do
      if(gamestate == "pause" or gamestate == "upgrading") then
        break
      end
      locX,locY = self:getLoc()
      locY = locY + math.random(-2,2)
      if(parent.team == 1 and locX < -130) then
        locX = locX + 1
      elseif (parent.team == 2 and locX > 130) then
        locX = locX - 1
      end
      self:setLoc(locX, locY)
      self.owner.checkReflect(self.owner)
      local gx, gy = self:getLoc()
      local cx, cy = prop:getLoc()
      local angle = calcAngle(gx,gy,cx,cy)
      parent.enemyBulletGen(parent, gx, gy, angle)

      coroutine.yield()
    end
  end

  self.prop.thread = MOAICoroutine.new()
  self.prop.thread:run(self.prop.moveEnemy, self.prop, self)
end

function Enemy.newEnemyBullet (origX, origY, angle)
    local enemyBullet = EnemyBullet.new(bsprite, origX, origY, angle)

    ebpartition:insertProp(enemyBullet.prop)
    enemyBullet:startThread()
end

function Enemy.enemyBulletGen(self, x, y, angle)
  if(self.enemyLast+self.enemyInterval < clock()) then
    self.newEnemyBullet(x, y, angle)
    self.enemyLast = clock()
  end
end

function Enemy.checkReflect(self)
  local x, y = self.prop:getLoc()
  local objs = ebrpartition:propListForRect(x-6, y-5, x+6, y+5)
  if(objs) then
    if(type(objs)=="table") then
      for i, hit in ipairs(objs) do
        self:damage(hit)
      end
    else
      self:damage(objs)
    end
  end
end

function Enemy.damage(self, obj)
  ebrpartition:removeProp(obj)
  obj.thread:stop()
  self.health = self.health - 100
  if (self.health <= 0 ) then
    elayer:removeProp(self.prop)
    self.prop.thread:stop()
  end
end

