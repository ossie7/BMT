waveCounter = 0

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
  rightKilled = 0
  
  currentWaveLeft = 1
  amountLeftEnemies = math.random(7,13) + (userdata.turn * 2) 
  totalAmountLeft = 0
  leftKilled = 0
  
  if(userdata.turn < 2 and showEngineer == false) then
    userdata.mission = "chased"
  end
  
  startTimer()
  prop:setLoc(0,0)
  startGuiThread()
  startShipThread()

end

function createEnemy(team, currentWave, totalAmount, amount, tim)
  currentAmount = math.random(math.floor(currentWave / 2) + 1, (amount / 20) + math.floor(currentWave / 2) + 1)
  print(team .. " +" .. currentAmount )
  if(totalAmount + currentAmount > amount) then
    currentAmount = amount - totalAmount
    totalAmount = amount
  else
    totalAmount = totalAmount + currentAmount
  end
  if (totalAmount <= amount) then
    for x=1, currentAmount do newEnemy(team) end
    currentWave = currentWave + 1
  else
    tim:stop()
  end
  return currentWave, totalAmount, amount
end

function startWaves() 
  timer = MOAITimer.new()
  timer:setMode(MOAITimer.LOOP)
  timer:setSpan(math.random(9,12))
  timer:setListener(MOAITimer.EVENT_TIMER_END_SPAN,
    function()
      currentWaveLeft, totalAmountLeft, amountLeftEnemies =
        createEnemy(1, currentWaveLeft, totalAmountLeft, amountLeftEnemies, timer)
    end)
  timer:start()
  currentWaveLeft, totalAmountLeft, amountLeftEnemies =
    createEnemy(1, currentWaveLeft, totalAmountLeft, amountLeftEnemies, timer)
  
  if(userdata.mission ~= "chased") then
    timer2 = MOAITimer.new()
    timer2:setMode(MOAITimer.LOOP)
    timer2:setSpan(math.random(9,12))
    timer2:setListener(MOAITimer.EVENT_TIMER_END_SPAN,
      function()
        currentWaveRight, totalAmountRight, amountRightEnemies =
          createEnemy(2, currentWaveRight, totalAmountRight, amountRightEnemies, timer2)
      end)
    timer2:start()
    currentWaveRight, totalAmountRight, amountRightEnemies =
      createEnemy(2, currentWaveRight, totalAmountRight, amountRightEnemies, timer2)
  end
end

function checkEndOfBattle()
  if(gamestate ~= "playing") then
    return
  end
  local earnedLoot = math.random(60,140)
  local wz = userdata.warzone
  if((amountLeftEnemies - leftKilled == 0)) then
    if(wz > 0 and userdata.showEngineer) then userdata.warzone = wz -1 end
    save_userdata()
    if(userdata.warzone == 0) then
      SetupNewUserdata()
      clearUpgrades()
      save_userdata()
      addPopup("GAME OVER", "The left team lost the war.\nStart a new adventure and try\n to keep the balance next time.", "OK", "loadMenuLayers")
    elseif(userdata.turn >= 1 and userdata.showEngineer == false) then 
      queuePopup({
        Popup.new("Mission Passed", "You saved the engineer!\n He can help you to improve your ship", "OK", nil),
        Popup.new("Mission Passed", "You can find him\nin your base.", "OK", "loadMenuLayers")
      })
      userdata.mission = ""
      userdata.showEngineer = true
      userdata.turn = userdata.turn + 1
      save_userdata()
     elseif(userdata.showEngineer or userdata.turn == 0) then
      addPopup("End of battle", "The left team has lost this battle \n you gained "..earnedLoot.." metal!", "OK", "loadMenuLayers")
      userdata.metal = userdata.metal + earnedLoot
      userdata.turn = userdata.turn + 1
      save_userdata()
    end
  elseif ((amountRightEnemies - rightKilled == 0) and userdata.mission ~= "chased") then
    if(wz < 10 and userdata.showEngineer) then userdata.warzone = wz +1 end
    save_userdata()
    if(userdata.warzone == 10) then
      SetupNewUserdata()
      clearUpgrades()
      save_userdata()
      addPopup("GAME OVER", "The right team lost the war.\nStart a new adventure and try\n to keep the balance next time.", "OK", "loadMenuLayers")
    else
      userdata.plasma = userdata.plasma + earnedLoot
      userdata.turn = userdata.turn + 1
      save_userdata()
      addPopup("End of battle", "The right team has lost this battle \n you gained "..earnedLoot.." plasma!", "OK", "loadMenuLayers")
    end
  end
end

function newEnemy (enemyTeam)
  local speed = 1
  local s = nil
  local x, y = 0, math.random(bottomborder + 30, topborder - 20)
  
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
  if(userdata.turn <= 1) then
    loadMenuLayers()
    return
  end
  
  local wz = userdata.warzone
  if(wz<5 and wz > 1) then userdata.warzone = wz - 1 end
  if(wz>5 and wz < 9) then userdata.warzone = wz + 1 end
  if(wz == 1 or wz == 9) then
    SetupNewUserdata()
    clearUpgrades()
    save_userdata()
    if(wz == 1) then
      addPopup("GAME OVER", "While your ship was being repaired\nthe left team lost the war.", "OK", "loadMenuLayers")
    else
      addPopup("GAME OVER", "While your ship was being repaired\nthe right team lost the war.", "OK", "loadMenuLayers")
    end
  end
  if(wz == 5) then
    local r = math.random()
    if(r > 0.5) then
      userdata.warzone = wz + 1
    else
      userdata.warzone = wz - 1
    end
  end
  userdata.turn = userdata.turn + 1
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
    if(ctouchY > -90 and userdata.mission ~= "chased" and gs2 ~= nil) then
      gs2:setLoc(70, bottomborder + ((cy + 90) / 18))
    end
    
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
  gs1 = cprop(guiStickSprite, -70, bottomborder)
  gl  = cprop(guiLifeSprite, 0, bottomborder+5)
  gd1 = cprop(digits, -400, -400)
  gd2 = cprop(digits, -400, -400)
  gd3 = cprop(digits, -400, -400)
  
  if(userdata.mission ~= "chased") then
    gb2 = cprop(guiBaseSprite, 70, bottomborder)
    gs2 = cprop(guiStickSprite, 70, bottomborder)
    guiLayer:insertProp(gb2)
    guiLayer:insertProp(gs2)
  end
  
  guiLayer:insertProp(lb)
  guiLayer:insertProp(rb)
  guiLayer:insertProp(gb1)
  guiLayer:insertProp(gs1)
  guiLayer:insertProp(gl)
  guiLayer:insertProp(gd1)
  guiLayer:insertProp(gd2)
  guiLayer:insertProp(gd3)
  
  guithread = MOAICoroutine.new()
  guithread:run(guiThread)
end
