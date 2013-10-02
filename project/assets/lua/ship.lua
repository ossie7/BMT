health = 999
bulletDamage = 100

gunActive = true

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
  if(last+interval < clock() and gunActive) then
    newBullet(x, y, angle)
    last = clock()
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
          --addPopup("Reflection", "You reflected\n a bullet!", "Ok", nil)
          queuePopup({
            Popup.new("Reflection", "You reflected\n a bullet!", "Ok", nil),
            Popup.new("Reflection", "Well done!", "Ok", nil),
            Popup.new("Reflection", "No really,\nwell done!", "Okay...", nil),
            Popup.new("Reflection", "YOU ARE\nAMAZING", "Shut up", nil)
          })
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
  SetShipColor(1, 0, 0, 1)
  if (health <= 0 ) then
    layer:removeProp(prop)
    print("ouch, hp is now "..health)
  end
end

function SetShipColor(r, g, b, a)
  prop:setColor(r, g, b, a)
end
