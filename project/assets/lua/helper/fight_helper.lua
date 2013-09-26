week = 0
waveCounter = 0
battleDone = 0

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
  last = clock() -- Last bullet spawn
  laste = clock() -- Last enemy spawn
  interval = 0.5 -- Bullet interval
  intervale = 1 -- Enemy interval
end

function startDuel(sprite, layer)
  createProp(sprite, layer)
  createGunTools()
  createUniverseBackground()

  currentWaveRight = 1
  amountRightEnemies = 5 -- TODO dynamisch maken
  totalAmountRight = 0
  lastWaveRight = false
  rightKilled = 0
  
  currentWaveLeft = 1
  amountLeftEnemies = 20 -- TODO dynamisch maken
  totalAmountLeft = 0
  lastWaveLeft = false
  leftKilled = 0
  
  startTimer()
  prop:setLoc(0,0)
  startPowerThread()
  startShipThread()

end

function createEnemyLeft()
  currentAmountLeft = math.random(currentWaveLeft, (amountLeftEnemies/10)+currentWaveLeft)

  if((totalAmountLeft + currentAmountLeft) > amountLeftEnemies) then
    currentAmountLeft = amountLeftEnemies - totalAmountLeft
    totalAmountLeft = amountLeftEnemies
    lastWaveLeft = true
  else
      totalAmountLeft = totalAmountLeft + currentAmountLeft
  end
  
  if (totalAmountLeft <= amountLeftEnemies) then
    
    for x=1, currentAmountLeft do
        newEnemy(1)
    end
    
    currentWaveLeft = currentWaveLeft + 1
  else
    timer:stop()
  end
  
end

function createEnemyRight()
  --totalWaves = math.random(week , week+2)
  currentAmountRight = math.random(currentWaveRight, (amountRightEnemies/10)+currentWaveRight)
  
  if(totalAmountRight + currentAmountRight > amountRightEnemies) then
    currentAmountRight = amountRightEnemies - totalAmountRight
    totalAmountRight = amountRightEnemies
    lastWaveRight = true
  else
      totalAmountRight = totalAmountRight + currentAmountRight
  end
  
  if (totalAmountRight <= amountRightEnemies) then
    
    for x=1, currentAmountRight do
        newEnemy(2)
        print(x)
    end
    
    currentWaveRight = currentWaveRight + 1
  else
    timer2:stop()
  end
  
end

function startWaves() 
  timer = MOAITimer.new()
  timer:setMode(MOAITimer.LOOP)
  timer:setSpan(math.random(9,12))
  timer:setListener(MOAITimer.EVENT_TIMER_END_SPAN, function() createEnemyLeft() end)
  timer:start()
  createEnemyLeft()
  
  timer2 = MOAITimer.new()
  timer2:setMode(MOAITimer.LOOP)
  timer2:setSpan(math.random(9,12))
  timer2:setListener(MOAITimer.EVENT_TIMER_END_SPAN, function() createEnemyRight() end)
  timer2:start()
  createEnemyRight()
end

function checkEndOfBattle()
<<<<<<< Updated upstream
  if(battleDone == 0) then
    local leftEnemies = epartition:propListForRect(-180,-90,180,90)
    local rightEnemies = epartition2:propListForRect(-180,-90,180,90)
    local wz = userdata.warzone
    if(leftEnemies == nil) then
      if(wz > 1) then userdata.warzone = wz -1 end
      save_userdata()
      loadMenuLayers()
      battleDone = 1
    elseif (rightEnemies == nil) then
      if(wz < 9) then userdata.warzone = wz +1 end
      save_userdata()
      loadMenuLayers()
      battleDone = 1
    end
=======
  local leftEnemies = epartition:propListForRect(-180,-90,180,90)
  local rightEnemies = epartition2:propListForRect(-180,-90,180,90)
  local wz = userdata.warzone
  if(leftEnemies == nil) then
    if(wz > 1) then userdata.warzone = wz -1 end
    save_userdata()
    endOfBattle(1)
  elseif (rightEnemies == nil) then
    if(wz < 9) then userdata.warzone = wz +1 end
    save_userdata()
    endOfBattle(2)
>>>>>>> Stashed changes
  end
end

function newEnemy (enemyTeam)
  local speed = 1
  local s = nil
  local x, y = 0, math.random(bottomborder + 10, topborder - 20)
  --local r = math.random(1,2)
  
  if(enemyTeam==1) then
    x = -180
    s = e1sprite
  else
    x = 180
    s= e2sprite
  end
  
  local newEnemy = Enemy.new(s, x, y, enemyTeam)
  if(enemyTeam == 1) then
    epartition:insertProp(newEnemy.prop)
  else
    epartition2:insertProp(newEnemy.prop)
  end
  newEnemy:startThread()
  newEnemy = nil
end

function calcAngle ( x1, y1, x2, y2 )
  return math.atan2 ( y2 - y1, x2 - x1 ) * ( 180 / math.pi )
end

function moveGun(gun, ship, cross)
  local gx, gy = ship:getLoc()
  local cx, cy = cross:getLoc()
  gun:setRot(calcAngle(gx,gy,cx,cy))
  gun:setLoc(gx,gy)
end

function checkCollision()
  local obj = ebpartition:propForPoint( prop:getLoc() )
  if obj then
    eblayer:removeProp(obj)
    layer:removeProp(obj)
  end
end

function powerThread()
  while true do
    if(gamestate == "pause" or gamestate == "upgrading" or gamestate == "endOfBattle") then
      break
    end
    local left = ((amountLeftEnemies-leftKilled)/amountLeftEnemies) * 150
    local right = ((amountRightEnemies-rightKilled)/amountRightEnemies) * -150
    lbsprite:setRect(0,0,left,-8)
    rbsprite:setRect(right,-8,0,0)
    coroutine.yield()
  end
end

function startPowerThread()
  lb = MOAIProp2D.new()
  lb:setDeck(lbsprite)
  lb:setLoc(leftborder + 10,topborder - 5)
  lb:setBlendMode( MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA )
  barlayer:insertProp(lb)

  rb = MOAIProp2D.new()
  rb:setDeck(rbsprite)
  rb:setLoc(rightborder - 10, topborder - 5)
  rb:setBlendMode( MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA )
  barlayer:insertProp(rb)
  
  powerthread = MOAICoroutine.new()
  powerthread:run(powerThread)
end
