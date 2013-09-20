week = 1
waveCounter = 0

currentWave = 0




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
  gun:setLoc(0,0)
  gun:setBlendMode( MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA )
  clayer:insertProp(gun)
end


function createUniverseBackground()
  universeThread(universeLayer)
end


function startTimer()
  clock = os.clock -- Create clock
  last = 0 -- Last bullet spawn
  laste = 0 -- Last enemy spawn
  interval = 0.2 -- Bullet interval
  intervale = 1 -- Enemy interval
end

function startDuel(sprite, layer)
  createProp(sprite, layer)
  createGunTools()
  createUniverseBackground()
  --createBackground() Oude sidescrolling background
  startTimer()
  prop:setLoc(0,0)
  startShipThread()
end

function enemyGenInterval()
  totalWaves = math.random(week , week+2)
  if (currentWave < totalWaves) then
    amountEnemies = math.random(3 , 10 )
    for x=1, amountEnemies do
        newEnemy()
        print(x)
    end
    currentWave = currentWave + 1
  else
    print("current wave = "..currentWave)
    print("times executed "..timer:getTimesExecuted())
    timer:stop()
    
    loadMenuLayers()
    currentWave = 1
    week = week + 1
  end
  
end

function startWaves() 
  timer = MOAITimer.new()
  timer:setMode(MOAITimer.LOOP)
  timer:setSpan(10)
  timer:setListener(MOAITimer.EVENT_TIMER_END_SPAN, function() enemyGenInterval() end)
  timer:start()
  enemyGenInterval()
end


function newEnemy ()
  local speed = 1
  local x, y = 0, math.random(bottomborder + 10, topborder - 10)
  local r = math.random(1,2)
  if(r==1) then x = -160 else x = 160 end
  local newEnemy = Enemy.new(esprite, x, y, r)
  epartition:insertProp(newEnemy.prop)
  newEnemy:startThread()
end

function calcAngle ( x1, y1, x2, y2 )
  return math.atan2 ( y2 - y1, x2 - x1 ) * ( 180 / math.pi )
end

function moveGun(gun, ship, cross)
  local gx, gy = ship:getLoc()
  local cx, cy = cross:getLoc()
  gun:setRot(calcAngle(gx+14,gy,cx,cy))
  gun:setLoc(gx+14,gy)
end

function checkCollision()
  local obj = ebpartition:propForPoint( prop:getLoc() )
  if obj then
    eblayer:removeProp(obj)
    layer:removeProp(obj)
  end
end
