health = 30
maxHealth = 30
bulletDamage = 100
gunActive = false
if(userdata.mission ~= "chased") then
  gunActive = true
end

function checkHealth() 
  return health
end


function newBullet (origX, origY, angle)
  local bestGunBuildIndex = 0
  
  if table.getn(shipUpgradesList) > 0 then
    for i = 1, table.getn(shipUpgradesList), 1 do
      local upgrade = shipUpgradesList[i]
      if upgrade:IsBuild() then
        bestGunBuildIndex = i
      end
    end
  end
  
  local buffedBulletDamage = bulletDamage + (bulletDamage * (bestGunBuildIndex * 0.05))
  
  local bullet = Bullet.new(bsprite, blayer, origX, origY, epartition, angle, bulletDamage)
  bpartition:insertProp(bullet.prop)
  bullet:startThread()
  bullet = nil
end

function bulletGen(x, y, angle)
  if(gunActive) then
    if(last + interval < clock()) then
      laserSound()
      newBullet(x, y, angle)
      last = clock()
    end
  else
    if(last + interval <clock()) then
      health = health + 0.1
      if health > maxHealth then health = maxHealth end
      last = clock()
    end
  end
end

function shipThread()
  while true do
    if(popupActive == false) then
    SetShipColor(1, 1, 1, 1)
    
    if(gamestate ~= "playing") then
      break
    end
    checkBulletCollision()
    local gx, gy = gun:getLoc()
    local cx, cy = cross:getLoc()
    local angle = calcAngle(gx,gy,cx,cy)
    bulletGen(gx, gy, angle)
    end
    coroutine.yield()
  end
end

function startShipThread ()
  health = maxHealth
  if(userdata.mission ~= "chased") then
    gunActive = true
  end
  shipthread = MOAICoroutine.new()
  shipthread:run(shipThread)
end

function checkBulletCollision()
  local obj = ebpartition:propForPoint(prop:getLoc() )
  local x,y = prop:getLoc()
  local robj = ebpartition:propListForRect(x-16, y-6, x-12, y+5)
  local hobj1 = ebpartition:propListForRect(x-11, y-6, x+4, y+5)
  local hobj2 = ebpartition:propListForRect(x+3, y-2, x+15, y+1)
  
  --Reflect
  if(robj) then
    if(type(robj)=="table") then
      for i, hit in ipairs(robj) do
        if(hit.owner.source == 1) then
          hit.owner:reflect()
        end
      end
    else
      if(robj.owner.source == 1) then
        robj.owner:reflect()
        if(popupActive == false) then -- POPUP SAMPLE CODE
          --addPopup("Reflection", "You reflected\na bullet!\nYay!", "Ok", nil)
          --[[queuePopup({
            Popup.new("Reflection", "You reflected\n a bullet!", "Ok", nil, spriteGoMenu),
            Popup.new("Reflection", "Well done!", "Ok", nil, spritePauseButton),
            Popup.new("Reflection", "No really,\nwell done!", "Okay...", nil),
            Popup.new("Reflection", "YOU ARE\nAMAZING", "Shut up", nil)
          })--]]
        end
      end
    end
  end
  
  --Hitbox 1
  if(hobj1) then
    if(type(hobj1)=="table") then
      for i, hit in ipairs(hobj1) do
        damage(hit)
      end
    else
      damage(hobj1)
    end
  end
  
  --Hitbox 2
  if(hobj2) then
    if(type(hobj2)=="table") then
      for i, hit in ipairs(hobj2) do
        damage(hit)
      end
    else
      damage(hobj2)
    end
  end
end

function damage(obj)
  obj.thread:stop()
  ebpartition:removeProp(obj)
  ebrpartition:removeProp(obj)
  health = health - 1
  if health < 0 then health = 0 end
  SetShipColor(1, 0, 0, 1)
  if (health <= 0 ) then
    battleDone = 1
    addPopup("You died", "You weren't able to keep\nbalance in the war.\nBut the war went on...","Ok","deadShip")
  end
end

function SetShipColor(r, g, b, a)
  prop:setColor(r, g, b, a)
end
