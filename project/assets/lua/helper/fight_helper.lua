waveCounter = 0
armVerticalOffset = 5
leftWon = nil

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
  gun = cprop(playerarm, gunX, armVerticalOffset)
  
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
  startWaves()
  addOverlay(battleOverlay, "Ok", nil)

end

function createEnemy(team, currentWave, totalAmount, amount, tim)
  currentAmount = math.random(math.floor(currentWave / 2) + 1, (amount / 20) + math.floor(currentWave / 2) + 1)
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
      if(popupActive == false) then
        currentWaveLeft, totalAmountLeft, amountLeftEnemies =
          createEnemy(1, currentWaveLeft, totalAmountLeft, amountLeftEnemies, timer)
      end
    end)
  timer:start()
  currentWaveLeft, totalAmountLeft, amountLeftEnemies =
    createEnemy(1, currentWaveLeft, totalAmountLeft, amountLeftEnemies, timer)
  
  if(userdata.mission ~= "chased" and userdata.turn >1) then
    timer2 = MOAITimer.new()
    timer2:setMode(MOAITimer.LOOP)
    timer2:setSpan(math.random(9,12))
    timer2:setListener(MOAITimer.EVENT_TIMER_END_SPAN,
      function()
        if(popupActive == false) then
          currentWaveRight, totalAmountRight, amountRightEnemies =
            createEnemy(2, currentWaveRight, totalAmountRight, amountRightEnemies, timer2)
        end
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
    timer:stop()
    if(timer2 ~= nil) then timer2:stop() end
    if(wz > 0 and userdata.showEngineer) then
      userdata.warzone = wz -1
      leftWon = false
    end
    save_userdata()
    if(userdata.warzone == 0) then
      SetupNewUserdata()
      clearUpgrades()
      save_userdata()
      addPopup("GAME OVER", "The left team lost the war.\nStart a new adventure and try\n to keep the balance next time.", "OK", "loadMenuLayers")
      return
    elseif(userdata.turn >= 1 and userdata.showEngineer == false) then 
      userdata.mission = ""
      userdata.showEngineer = true
      userdata.turn = userdata.turn + 1
      save_userdata()
      queuePopup({
        Popup.new("Mission Passed", "You saved the engineer!\n He can improve your ship.", "OK", nil),
        Popup.new("Mission Passed", "You can find him\nat your base.", "OK", "loadMenuLayers")
      })
     elseif(userdata.showEngineer or userdata.turn == 0) then
      userdata.metal = userdata.metal + earnedLoot
      userdata.turn = userdata.turn + 1
      save_userdata()
      addPopup("End of battle", "The left team has lost this battle \n you earned "..earnedLoot.." metal!", "OK", "loadMenuLayers")
    end
  elseif ((amountRightEnemies - rightKilled == 0) and userdata.mission ~= "chased") then
    timer:stop()
    if(timer2 ~= nil) then timer2:stop() end
    if(wz < 10 and userdata.showEngineer) then
      userdata.warzone = wz +1
      leftWon = true
    end
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
      addPopup("End of battle", "The right team has lost this battle \n you earned "..earnedLoot.." plasma!", "OK", "loadMenuLayers")
    end
  end
end

function newEnemy (team)
  local s = nil
  local layer = nil
  local x, y = 0, math.random(bottomborder + 30, topborder - 20)
  local ship = math.random(1, 3)
  
  if(team == 1) then
    x = -180
  else
    x = 180
  end
  
  if(    team == 1 and ship == 1) then s = e1sprite
  elseif(team == 1 and ship == 2) then s = e1sprite
  elseif(team == 1 and ship == 3) then s = e1sprite
  elseif(team == 2 and ship == 1) then s = e2sprite
  elseif(team == 2 and ship == 2) then s = e2sprite
  elseif(team == 2 and ship == 3) then s = e2sprite end
    
  
  local newEnemy = Enemy.new(s, x, y, team, ship)
  if(team == 1) then
    epartition:insertProp(newEnemy.prop)
    elayer:insertProp(newEnemy.gun)
  else
    epartition2:insertProp(newEnemy.prop)
    elayer2:insertProp(newEnemy.gun)
  end
  newEnemy:startThread()
  newEnemy = nil
end

function calcAngle ( x1, y1, x2, y2 )
  return math.atan2 ( y2 - y1, x2 - x1 ) * ( 180 / math.pi )
end

function moveGun(gun, ship, cross)
  local gx, gy = ship:getLoc()
  gy = gy + armVerticalOffset
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
  timer:stop()
  if(timer2 ~= nil) then timer2:stop() end
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
      addPopup("GAME OVER", "While your ship was being repaired,\nthe left team lost the war.", "OK", "loadMenuLayers")
      return
    else
      addPopup("GAME OVER", "While your ship was being repaired,\nthe right team lost the war.", "OK", "loadMenuLayers")
      return
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
  save_userdata()
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
  gb1 = cprop(guiBaseSprite, -70, bottomborder)
  gs1 = cprop(guiStickSmallSprite, -70, bottomborder)
  gl  = cprop(guiLifeSprite, 0, bottomborder+5)
  gd1 = cprop(digits, -400, -400)
  gd2 = cprop(digits, -400, -400)
  gd3 = cprop(digits, -400, -400)
  
  if(userdata.mission ~= "chased") then
    rb  = cprop(rbsprite, rightborder - 10, topborder - 5)
    gb2 = cprop(guiBaseSprite, 70, bottomborder)
    gs2 = cprop(guiStickSmallSprite, 70, bottomborder)
    guiLayer:insertProp(rb)
    guiLayer:insertProp(gb2)
    guiLayer:insertProp(gs2)
  end
  
  guiLayer:insertProp(lb)
  guiLayer:insertProp(gb1)
  guiLayer:insertProp(gs1)
  guiLayer:insertProp(gl)
  guiLayer:insertProp(gd1)
  guiLayer:insertProp(gd2)
  guiLayer:insertProp(gd3)
  
  guithread = MOAICoroutine.new()
  guithread:run(guiThread)
end
