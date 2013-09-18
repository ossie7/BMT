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
