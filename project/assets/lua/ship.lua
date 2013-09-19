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
    if(gamestate == "pause") then
      break
    end
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
  if obj then
    ebpartition:removeProp(obj)
    health = health - 1
    textboxHealth:setString("Health = "..health)
    if (health <= 0 ) then
        layer:removeProp(prop)
        print("ouch, hp is now "..health)
    end
    
  end
end
