health = 999

function checkHealth() 
    return health
end


function newBullet (origX, origY, angle)
    local bullet = Bullet.new(bsprite, blayer, origX, origY, epartition, angle)
    blayer:insertProp(bullet.prop)
    bullet:startThread()
end

function bulletGen(x, y, angle)
  if(last+interval < clock()) then
    newBullet(x, y, angle)
    last = clock()
  end
end

function shipThread()
  while true do
    if(gamestate == "pause" or gamestate == "upgrading") then
      break
    end
    checkBulletCollision()
    local gx, gy = gun:getLoc()
    local cx, cy = cross:getLoc()
    local angle = calcAngle(gx,gy,cx,cy)
    bulletGen(gx, gy, angle)
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
  local robj = ebpartition:propListForRect(x-15, y-5, x-12, y+4)
  local hobj1 = ebpartition:propListForRect(x-11, y-6, x+4, y+5)
  local hobj2 = ebpartition:propListForRect(x+3, y-2, x+15, y+1)
  
  --Reflect
  if(robj) then
    if(type(robj)=="table") then
      for i, hit in ipairs(robj) do
        hit.owner:reflect()
      end
    else
      robj.owner:reflect()
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
  textboxHealth:setString("Health = "..health)
  if (health <= 0 ) then
    layer:removeProp(prop)
    print("ouch, hp is now "..health)
  end
end

