Enemy = {}
Enemy.__index = Enemy

-- syntax equivalent to "MyClass.new = function..."
function Enemy.new(sprite, x, y, team)
  self = setmetatable({}, Enemy)

  self.team = team
  self.target = nil
  self.health = 100
  if(team == 1) then
    self.damage = 50
  else
    self.damage = 100
  end
  self.enemyLast = clock() + math.random() + math.random()
  self.enemyInterval = 1.5 + math.random() + math.random()
  self.entryLoc = math.random(130,140)
  self.prop = MOAIProp2D.new()
  self.prop:setDeck(sprite)
  self.prop:setLoc(x, y)
  self.prop:setBlendMode( MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA )
  self.prop.owner = self
  
  return self
end

function wait ( action )
    while action:isBusy () do coroutine:yield () end
end

function Enemy.startThread (self)
  
  function self.prop:moveEnemy(parent)
    while true do
      if(gamestate == "pause" or gamestate == "upgrading") then
        parent:die()
      end
      locX,locY = self:getLoc()
      if(parent.team == 1 and locX < (parent.entryLoc * -1)) then
        locX = locX + 1
        self:setLoc(locX, locY)
      elseif (parent.team == 2 and locX > parent.entryLoc) then
        locX = locX - 1
        self:setLoc(locX, locY)
      end
      
      if(parent.team == 1 and locX >= -130) then
        local newX = math.random(-10,10)
        local newY = math.random(-10,10)
        if((newX + locX) >= -110) then
          newX = 0
        end
        if ((newY + locY) <= -80 or (newY + locY) >= 70) then
          newY = 0
        end
        wait(self:moveLoc(newX, newY, 3))
      end
      
      if(parent.team == 2 and locX <= 130) then
        local newX = math.random(-3,3)
        local newY = math.random(-3,3)
        if((newX + locX) <= 110) then
          newX = 0
        end
        if ((newY + locY) <= -80 or (newY + locY) >= 70) then
          newY = 0
        end
        wait(self:moveLoc(newX, newY, 3))
      end
      coroutine.yield()
    end
  end

  self.prop.thread = MOAICoroutine.new()
  self.prop.thread:run(self.prop.moveEnemy, self.prop, self)
  self.thread = MOAICoroutine.new()
  self.thread:run(self.hitThread, self)
end

function Enemy.hitThread(self)
  while true do
    if(gamestate == "pause" or gamestate == "upgrading") then
      self:die()
    end
    local x, y = self.prop:getLoc()
    self:checkAllHits(bpartition:propListForRect(x-6, y-5, x+6, y+5))
    self:checkAllHits(ebpartition:propListForRect(x-6, y-5, x+6, y+5))
    self:checkAllHits(ebrpartition:propListForRect(x-6, y-5, x+6, y+5))
    self:enemyBulletGen(x, y)
    coroutine.yield()
  end
end

function Enemy.newEnemyBullet (self, origX, origY, angle)
  local sprite = nil
  if(self.team == 1) then
    sprite = eb1sprite
  else
    sprite = eb2sprite
  end
  local enemyBullet = EnemyBullet.new(sprite, origX, origY, angle, self.team, self.damage)
  ebpartition:insertProp(enemyBullet.prop)
  enemyBullet:startThread()
  enemyBullet = nil
end

function Enemy.enemyBulletGen(self, x, y)
  if(self.target == nil) then
    local ot = nil
    if(self.team == 1) then
      ot = epartition2
    else
      ot = epartition
    end
  
    local e = ot:propListForRect(-160, -90, 160, 90)
    if(e) then
      if(type(e)=="table") then
        local n = table.getn(e)
        self.target = e[math.random(1,n)]
      else
        self.target = e
      end
    end
  else
    if(self.target.owner.health > 0) then
      if(self.enemyLast+self.enemyInterval < clock()) then
        local tx, ty = self.target:getLoc()
        local angle = calcAngle(x, y, tx, ty)
        self:newEnemyBullet(x, y, angle)
        self.enemyLast = clock()
      end
    else
      self.target = nil
    end
  end
end

function Enemy.checkAllHits(self, objs)
  if(objs) then
    if(type(objs)=="table") then
      for i, hit in ipairs(objs) do
        if(hit.owner.source == nil or (self.team ~= hit.owner.source)) then
          self:damageTaken(hit)
        end
      end
    else
      if(objs.owner.source == nil or (self.team ~= objs.owner.source)) then
        self:damageTaken(objs)
      end
    end
  end
end

function Enemy.damageTaken(self, obj)
  local damage = obj.owner.damage
  bpartition:removeProp(obj)
  ebpartition:removeProp(obj)
  ebrpartition:removeProp(obj)
  obj.owner:die()
  
  self.health = self.health - damage
  
  coins = coins + 1
  textboxGameMode:setString("Coins = "..coins)
  
  if (self.health <= 0 ) then
    self:die()
  end
end

function Enemy.die(self)
  elayer:removeProp(self.prop)
  elayer2:removeProp(self.prop)
  if(lastWaveRight == true or lastWaveLeft == true) then
    checkEndOfBattle()
  end
  if(self.team == 1) then
    leftKilled = leftKilled + 1
  else
    rightKilled = rightKilled + 1
  end
  MOAISim.forceGarbageCollection()
  self.prop.thread:stop()
  self.thread:stop()
  self.prop = nil
  self = nil
  
end
