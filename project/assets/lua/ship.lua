health = 100

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
  local robj = ebpartition:propListForRect(x-24, y-16, x-18, y+16)
  local hobj = ebpartition:propListForRect(x-18, y-14, x+22, y+14)
  
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
  
  --Hit
  if(hobj) then
    if(type(hobj)=="table") then
      for i, hit in ipairs(hobj) do
        damage(hit)
      end
    else
      damage(hobj)
    end
  end
end

function damage(obj)
  ebpartition:removeProp(obj)
  health = health - 1
  textboxHealth:setString("Health = "..health)
  if (health <= 0 ) then
    layer:removeProp(prop)
    print("ouch, hp is now "..health)
  end
end

