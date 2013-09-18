function createProp(sprite, layer)
  prop = MOAIProp2D.new()
  prop:setDeck(sprite)
  prop:setBlendMode( MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA )
  layer:insertProp(prop)
end

function createGunTools()
  cross = MOAIProp2D.new()
  cross:setDeck(csprite)
  cross:setLoc(100,0)
  cross:setBlendMode( MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA )
  clayer:insertProp(cross)

  gun = MOAIProp2D.new()
  gun:setDeck(gunsprite)
  gun:setLoc(-86,0)
  gun:setBlendMode( MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA )
  clayer:insertProp(gun)
end

function createBackground()
  backgroundThread(backgroundLayer1, backgroundLayer2)
end


function startTimer()
  clock = os.clock -- Create clock
  last = 0 -- Last bullet spawn
  laste = 0 -- Last enemy spawn
  interval = 0.2 -- Bullet interval
  intervale = 1 -- Enemy interval
end

function startDuel(sprite, layer)
  layer:clear()
  createProp(sprite, layer)
  createGunTools()
  createBackground()
  startTimer()
  prop:setLoc(-100,0)
end

function bulletGen(x, y)
  if(last+interval < clock()) then
    newBullet(x,y)
    last = clock()
  end
end

function enemyGenInterval()
  if(laste+intervale < clock()) then
    newEnemy()
    laste = clock()
  end
end

function newEnemy ()
  local x, y = 0,0
  x = 100
  y = math.random(bottomborder + 10, topborder - 10)
  local enemy = MOAIProp2D.new()
  enemy:setDeck(esprite)
  enemy:setLoc(x, y)
  enemy:setBlendMode( MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA )
  epartition:insertProp(enemy)
end

function angle ( x1, y1, x2, y2 )
  return math.atan2 ( y2 - y1, x2 - x1 ) * ( 180 / math.pi )
end

function moveGun(gun, ship, cross)
  local gx, gy = ship:getLoc()
  local cx, cy = cross:getLoc()
  gun:setRot(angle(gx+14,gy,cx,cy))
  gun:setLoc(gx+14,gy)
end
