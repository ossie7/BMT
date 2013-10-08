Enemy = {}
Enemy.__index = Enemy

function Enemy.new(x, y, team, ship)
  self = setmetatable({}, Enemy)

  self.team = team
  self.target = nil
  self.ship = ship
  
  if(    team == 1 and ship == 1) then self:stats(50,   100, 0.5)
  elseif(team == 1 and ship == 2) then self:stats(50,   600, 3)
  elseif(team == 1 and ship == 3) then self:stats(600,  200, 1.5)
  elseif(team == 2 and ship == 1) then self:stats(100,  200, 1.2)
  elseif(team == 2 and ship == 2) then self:stats(100,  600, 3)
  elseif(team == 2 and ship == 3) then self:stats(1200, 400, 3) end
  
  self.isArrived = false
  self.enemyLast = clock() + math.random()
  if(team == 1) then
    self.enemyInterval = self.intervalBase + math.random() + math.random()
  else
    self.enemyInterval = self.intervalBase + math.random() + math.random()
  end
  
  self.entryLoc = 140 --math.random(130,145)
  
  self.prop = GetEnemyAnimationProp(team, ship)
  self.prop:setLoc(x, y)
  self.animation = GetEnemyAnimation(self.prop, team, ship)
  self.animation:start()
  
  self.gun = GetEnemyGun(team, ship, x, y)
  local offsetX, offsetY = GetEnemyGunOffset(team, ship)
  self.gunOffsetX = offsetX 
  self.gunOffsetY = offsetY
  
  self.prop.owner = self
  self.gun.owner = self
  
  return self
end

function Enemy.stats(self, health, damage, interval)
  self.health = health
  self.damage = damage
  self.intervalBase = interval
end

function Enemy.wait(self, action )
  while action:isBusy() do
    self:rotGun()
    coroutine:yield()
  end
end

function Enemy.startThread (self)
  
  function self.prop:moveEnemy(parent)
    while true do
      if(popupActive == false) then
      if(gamestate ~= "playing") then
        parent:remove()
      end
      locX,locY = self:getLoc()
      if(parent.team == 1 and locX <= (parent.entryLoc * -1)) then
        
        parent:moveIn(1, locX, locY)
        if(locX == (parent.entryLoc *-1)-1 and userdata.mission == "chased" and parent.isArrived == false and popupGiven == false) then
          if(userdata.turn == 0) then
            queuePopup({Popup.new("Escape!", "Oh dear, you are being chased!\n Get away by reflecting bullets!", "OK", nil)})
            popupGiven = true
          elseif(userdata.turn > 0 and userdata.showEngineer == false) then
            queuePopup({Popup.new("Rescue Mission", "There's someone in need!\n Kill the pursuers and save him.", "OK", nil)})
            popupGiven = true
          end
        end
      elseif (parent.team == 2 and locX >= parent.entryLoc) then  
        parent:moveIn(2, locX, locY)
      end

      if(parent.team == 1 and parent.isArrived) then
        local newX = math.random(-10,10)
        local newY = math.random(-20,20)
        if((newX + locX) >= -110 or (newX + locX) <= -150) then
          newX = 0
        end
        if ((newY + locY) <= -60 or (newY + locY) >= 70) then
          newY = 0
        end
        parent:wait(self:moveLoc(newX, newY, math.random() + math.random(1,2)))
      end
      
      if(parent.team == 2 and parent.isArrived) then
        local newX = math.random(-10,10)
        local newY = math.random(-20,20)
        if((newX + locX) <= 110 or (newX + locX) >= 150) then
          newX = 0
        end
        if ((newY + locY) <= -60 or (newY + locY) >= 70) then
          newY = 0
        end
        parent:wait(self:moveLoc(newX, newY, math.random() + math.random(1,2)))
      end
      parent.rotGun(parent)
      end
      coroutine.yield()
    end
  end

  self.prop.thread = MOAICoroutine.new()
  self.prop.thread:run(self.prop.moveEnemy, self.prop, self)
  self.thread = MOAICoroutine.new()
  self.thread:run(self.hitThread, self)
end

function Enemy.moveIn(self, teamId, x, y)
  if(teamId == 1 and self.isArrived == false) then
    self.prop:setLoc(x + 1, y)
    if(x >= -140) then
      self.isArrived = true
    end
  elseif(teamId == 2 and self.isArrived == false) then
    self.prop:setLoc(x - 1, y)
    if(x <= 140) then
      self.isArrived = true
    end
  end
end


function Enemy.hitThread(self)
  while true do
    if(popupActive == false) then
    self:setShipColor(1, 1, 1, 1)
    if(gamestate ~= "playing") then
      self:die()
    end
    
    local sa
    if(    self.team == 1 and self.ship == 1) then sa = {-6,  -5,  6,  5}
    elseif(self.team == 1 and self.ship == 2) then sa = {-6,  -5,  6,  5}
    elseif(self.team == 1 and self.ship == 3) then sa = {-6,  -5,  6,  5}
    elseif(self.team == 2 and self.ship == 1) then sa = {-6,  -5,  6,  5}
    elseif(self.team == 2 and self.ship == 2) then sa = {-6,  -5,  6,  5}
    elseif(self.team == 2 and self.ship == 3) then sa = {-6,  -5,  6,  5} end
    
    local x, y = self.prop:getLoc()
    self:checkAllHits(bpartition:propListForRect(  x + sa[1], y + sa[2], x + sa[3], y + sa[4]))
    self:checkAllHits(ebpartition:propListForRect( x + sa[1], y + sa[2], x + sa[3], y + sa[4]))
    self:checkAllHits(ebrpartition:propListForRect(x + sa[1], y + sa[2], x + sa[3], y + sa[4]))
    self:enemyBulletGen(x, y)
    end
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
  if(self.team == 1) then enemyBullet:setScl(2) end
  enemyBullet:startThread()
  enemyBullet = nil
end

function Enemy.enemyBulletGen(self, x, y)
  if(userdata.mission == "chased" or self.ship == 2) then
    self.target = prop
  end
    
  if(self.target == nil) then
    self.target = newTarget(self.team)
  elseif(self.target == prop or self.target.owner.health > 0) then
    if(self.enemyLast+self.enemyInterval < clock()) then
      local tx, ty = self.target:getLoc()
      local angle = calcAngle(x, y, tx, math.random(ty - 10, ty + 10))
      self:newEnemyBullet(x, y, angle)
      self.enemyLast = clock()
    end
  else
    self.target = nil
  end
end

function Enemy.rotGun(self)
  local gx, gy = self.prop:getLoc()
  if(self.target ~= nil) then
    local cx, cy = self.target:getLoc()
    self.gun:setRot(calcAngle(gx,gy,cx,cy))
  else
    self.gun:setRot(0)
  end
  self.gun:setLoc(gx + self.gunOffsetX, gy + self.gunOffsetY)
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
  self:setShipColor(1, 0, 0, 1)
  if (self.health <= 0 ) then
    self:die()
  end
end

function Enemy.setShipColor(self, r, g, b, a)
  self.prop:setColor(r, g, b, a)
end

function Enemy.remove(self)
  elayer:removeProp(self.prop)
  elayer2:removeProp(self.prop)
  MOAISim.forceGarbageCollection()
  self.prop.thread:stop()
  self.thread:stop()
  self.prop = nil
  self = nil
end

function Enemy.die(self)
  local xDie,yDie = self.prop:getLoc()

  explodeSound()
  elayer:removeProp(self.prop)
  elayer2:removeProp(self.prop)
  elayer:removeProp(self.gun)
  elayer2:removeProp(self.gun)
  
  if(self.team == 1) then
    leftKilled = leftKilled + 1
  else
    rightKilled = rightKilled + 1
  end
  checkEndOfBattle()
  
  runExplosion(xDie, yDie)
  
  if self.team == 1 and self.ship == 2 then
    leftTeamSnipersAmount = leftTeamSnipersAmount - 1
  elseif self.team == 1 and self.ship == 3 then
    leftTeamTanksAmount = leftTeamTanksAmount - 1
  elseif self.team == 2 and self.ship == 2 then
    rightTeamSnipersAmount = rightTeamSnipersAmount - 1
  elseif self.team == 2 and self.ship == 3 then
    rightTeamTanksAmount = rightTeamTanksAmount - 1
  end
  
  MOAISim.forceGarbageCollection()
  self.prop.thread:stop()
  self.thread:stop()
  self.prop = nil
  self.gun = nil
  self = nil
end

function runExplosion(xDie, yDie)
  
  local anim = MOAIAnim.new()
  anim:reserveLinks(1) -- aantal curves
  anim:setLink(1, curve, propExplosion, MOAIProp2D.ATTR_INDEX )
  anim:setMode(MOAITimer.NORMAL)
  anim:setSpan(9 * 0.05)
  anim:start()
  propExplosion:setLoc(xDie, yDie)
  exlayer:insertProp(propExplosion)

  local explTimer = MOAITimer.new()
  explTimer:setMode(MOAITimer.NORMAL)
  explTimer:setSpan(anim:getLength())
  explTimer:setListener(MOAITimer.EVENT_TIMER_END_SPAN, function() exlayer:removeProp(propExplosion) end)
  explTimer:start()

end
