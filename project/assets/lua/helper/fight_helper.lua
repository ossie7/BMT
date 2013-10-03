waveCounter = 0
battleDone = 0
-- chased, sandwiched
if(userdata.turn < 2) then
  userdata.mission = "chased"
end


function createProp(sprite, layer)
  prop = cprop(sprite, 0, 0)
  layer:insertProp(prop)
end

function createGunTools()
  local gunX = 0
  local crossX = 140
  if(userdata.mission == "chased") then
    gunX = 200
    crossX = 200
  end
  
  cross = cprop(csprite, crossX, 0)
  gun = cprop(gunsprite, gunX, 0)
  
  clayer:insertProp(cross)
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
end

function startDuel(sprite, layer)
  createProp(sprite, layer)
  createGunTools()

  createUniverseBackground()

  popupGiven = false --Mission popup
  currentWaveRight = 1
  amountRightEnemies = math.random(7,13) + (userdata.turn * 2)
  totalAmountRight = 0
  lastWaveRight = false
  rightKilled = 0
  
  currentWaveLeft = 1
  amountLeftEnemies = math.random(7,13) + (userdata.turn * 2) 
  totalAmountLeft = 0
  lastWaveLeft = false
  leftKilled = 0
  
  startTimer()
  prop:setLoc(0,0)
  startGuiThread()
  startShipThread()

end

function createEnemyLeft()
  currentAmountLeft = math.random(currentWaveLeft, (amountLeftEnemies/20)+currentWaveLeft)

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
    end
    currentWaveRight = currentWaveRight + 1
  else
    timer2:stop()
  end
end

function startWaves() 
  if(userdata.mission == "chased" or userdata.mission == "") then
    timer = MOAITimer.new()
    timer:setMode(MOAITimer.LOOP)
    timer:setSpan(math.random(9,12))
    timer:setListener(MOAITimer.EVENT_TIMER_END_SPAN, function() createEnemyLeft() end)
    timer:start()
    createEnemyLeft()
  end
  if(userdata.mission ~= "chased") then
    timer2 = MOAITimer.new()
    timer2:setMode(MOAITimer.LOOP)
    timer2:setSpan(math.random(9,12))
    timer2:setListener(MOAITimer.EVENT_TIMER_END_SPAN, function() createEnemyRight() end)
    timer2:start()
    createEnemyRight()
  end
end

function checkEndOfBattle()
  if(battleDone == 0) then
    local leftEnemies = epartition:propListForRect(-180,-90,180,90)
    local rightEnemies = epartition2:propListForRect(-180,-90,180,90)
    local earnedLoot = 100
    local wz = userdata.warzone
    if(leftEnemies == nil and lastWaveLeft) then
      if(wz > 0 and userdata.showEngineer) then userdata.warzone = wz -1 end
      save_userdata()
      if(userdata.warzone == 0) then
        SetupNewUserdata()
        clearUpgrades()
        save_userdata()
        addPopup("You lost", "Loooser", "OK", "loadMenuLayers")
      elseif(userdata.turn >= 1 and userdata.showEngineer == false) then 
        queuePopup({
          Popup.new("Mission Passed", "You saved the engineer!\n He can help you to improve your ship", "OK", nil),
          Popup.new("Mission Passed", "You can find him\nin your base.", "OK", nil),
          Popup.new("Mission Passed", "Click on him to add\nupgrades to your ship.", "OK", "loadMenuLayers")
        })
        userdata.mission = ""
        userdata.showEngineer = true
        save_userdata()
       elseif(userdata.showEngineer or userdata.turn == 0) then
        addPopup("End of battle", "The left team has lost this battle \n you gained "..earnedLoot.." metal!", "OK",          "loadMenuLayers")
        userdata.metal = userdata.metal + earnedLoot
        userdata.turn = userdata.turn + 1
        save_userdata()
      end
      battleDone = 1
      
      
    elseif (rightEnemies == nil and userdata.mission ~= "chased") then
      if(wz < 9 and userdata.showEngineer) then userdata.warzone = wz +1 end
      save_userdata()
      if(userdata.warzone == 9) then
        SetupNewUserdata()
        clearUpgrades()
        save_userdata()
        addPopup("You lost", "Loooser", "OK", "loadMenuLayers")
      else
        -- needs testing
        addPopup("End of battle", "The right team has lost this battle \n you gained "..earnedLoot.." plasma!", "OK", "loadMenuLayers")
        userdata.plasma = userdata.plasma + earnedLoot
        userdata.turn = userdata.turn + 1
        save_userdata()
      end
      battleDone = 1
      
      
    end
  end
end

function newEnemy (enemyTeam)
  local speed = 1
  local s = nil
  local x, y = 0, math.random(bottomborder + 30, topborder - 20)
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

function deadShip()
  local wz = userdata.warzone
  if(wz<5 and wz > 1) then userdata.warzone = wz - 1 end
  if(wz>5 and wz < 9) then userdata.warzone = wz + 1 end
  if(wz == 1 or wz == 9) then
    SetupNewUserdata()
    clearUpgrades()
    save_userdata()
    addPopup("You lost", "Loooser", "OK", "loadMenuLayers")
  end
  if(wz == 5) then
    local r = math.random()
    if(r > 0.5) then
      userdata.warzone = wz + 1
    else
      userdata.warzone = wz - 1
    end
  end
  loadMenuLayers()
end

function guiThread()
  while true do
    if(gamestate ~= "playing") then
      break
    end
    local left = ((amountLeftEnemies-leftKilled)/amountLeftEnemies) * 150
    local right = ((amountRightEnemies-rightKilled)/amountRightEnemies) * -150
    lbsprite:setRect(0,0,left,-8)
    rbsprite:setRect(right,-8,0,0)
    
    local px, py = prop:getLoc()
    local cx, cy = cross:getLoc()
    
    if(touchY  > -90) then gs1:setLoc(-70, bottomborder + ((py + 90) / 18)) end
    if(ctouchY > -90) then gs2:setLoc(70, bottomborder + ((cy + 90) / 18)) end
    
    local percent = (health/maxHealth)*100
    gd1:setIndex(math.floor(percent / 100) + 1)
    gd2:setIndex(math.floor((percent % 100) / 10) + 1)
    gd3:setIndex((percent % 10) + 1)
    
    if(percent >= 100) then
      gd1:setLoc(-12, bottomborder+29)
      gd2:setLoc(0, bottomborder+29)
      gd3:setLoc(12, bottomborder+29)
    elseif(percent >= 10) then
      gd1:setLoc(-400, -400)
      gd2:setLoc(-8, bottomborder+29)
      gd3:setLoc(8, bottomborder+29)
    else
      gd1:setLoc(-400, -400)
      gd2:setLoc(-400, -400)
      gd3:setLoc(0, bottomborder+29)
    end
    
    gd1:setColor(((maxHealth-health)/maxHealth), (health/maxHealth), 0, 1)
    gd2:setColor(((maxHealth-health)/maxHealth), (health/maxHealth), 0, 1)
    gd3:setColor(((maxHealth-health)/maxHealth), (health/maxHealth), 0, 1)
    gl:setColor(((maxHealth-health)/maxHealth), (health/maxHealth), 0, 1)
    coroutine.yield()
  end
end

function startGuiThread()
  lb  = cprop(lbsprite, leftborder + 10, topborder - 5)
  rb  = cprop(rbsprite, rightborder - 10, topborder - 5)
  gb1 = cprop(guiBaseSprite, -70, bottomborder)
  gb2 = cprop(guiBaseSprite, 70, bottomborder)
  gs1 = cprop(guiStickSprite, -70, bottomborder)
  gs2 = cprop(guiStickSprite, 70, bottomborder)
  gl  = cprop(guiLifeSprite, 0, bottomborder+5)
  gd1 = cprop(digits, -400, -400)
  gd2 = cprop(digits, -400, -400)
  gd3 = cprop(digits, -400, -400)
  
  guiLayer:insertProp(lb)
  guiLayer:insertProp(rb)
  guiLayer:insertProp(gb1)
  guiLayer:insertProp(gb2)
  guiLayer:insertProp(gs1)
  guiLayer:insertProp(gs2)
  guiLayer:insertProp(gl)
  guiLayer:insertProp(gd1)
  guiLayer:insertProp(gd2)
  guiLayer:insertProp(gd3)
  
  guithread = MOAICoroutine.new()
  guithread:run(guiThread)
end
