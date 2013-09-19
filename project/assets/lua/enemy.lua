Enemy = {}
Enemy.__index = Enemy

-- syntax equivalent to "MyClass.new = function..."
function Enemy.new(sprite, x, y, team)
  self = setmetatable({}, Enemy)
  self.prop = MOAIProp2D.new()
  self.team = team
  self.prop:setDeck(sprite)
  self.prop:setLoc(x, y)
  self.enemyLast = 0
  self.enemyInterval = 1
  self.prop:setBlendMode( MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA )
  return self
end


function Enemy.startThread (self)
  
  function self.prop:moveEnemy(parent)
    while true do
      locX,locY = self:getLoc()
      newY = locY + math.random(-2,2)
      self:setLoc(locX, newY)
      -----
      local gx, gy = self:getLoc()
      local cx, cy = prop:getLoc()
      local angle = calcAngle(gx,gy,cx,cy)
      parent.enemyBulletGen(parent, gx, gy, angle)
    ---------
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


