local lastX = 0
local lastY = 0
local clastX = 0
local clastY = 0

local touchX = 0
local touchY = 0
local ctouchX = 0
local ctouchY = 0

local swipeStartX = 0
local swipeStartY = 0
local swipeLastX = 0
local swipeLastY = 0
local minSwipeDistance = 20

shipDeltaY = 0
gunDeltaY = 0
drag = false
event = nil

function mouseInput(down)
  local x, y = MOAIInputMgr.device.pointer:getLoc()
  if (down == true and drag == true) then
    event = MOAITouchSensor.TOUCH_MOVE
  elseif( down == false and drag) then
    event = MOAITouchSensor.TOUCH_UP
    drag = false
    mouseMove(x, y)
    event = nil
  elseif( down and drag == false) then
    event = MOAITouchSensor.TOUCH_DOWN
    drag = true
    mouseMove(x, y)
    event = MOAITouchSensor.TOUCH_MOVE
  end
end

function mouseMove(x, y)
  if(event) then
    touchInput(event, 1, x, y, 1)
  end
end

function touchInput(event, idx, x, y, tapCount)
  if(gamestate == "playing") then
    playInput(event, idx, x, y)
  elseif(gamestate == "upgrading") then
    upgradeInput(event, idx, x, y)
  elseif(gamestate == "endOfBattle") then
    eobInput(event, idx, x, y)
  elseif(gamestate == "pause") then
    baseInput(event, idx, x, y)
  end
end

function playInput(event, idx, x, y)
  local ax, ay = layer:wndToWorld(x, y)
  
  if prop ~= nil then
    if (event == 1 and ax >= -120 and ax <= -40 and ay <= -40) then
      shipDeltaY = (ay - touchY) * 3
      prop:moveLoc ( 0, shipDeltaY, 0, 0, MOAIEaseType.FLAT )
    elseif(event == 1 and ax <= 120 and ax >= 40 and ay <= -40) then
      gunDeltaY = (ay - ctouchY) * 3
      cross:moveLoc ( 0, gunDeltaY, 0, 0, MOAIEaseType.FLAT )
    end
    if(ax >= -120 and ax <= -40 and ay <= 0) then
      touchX = ax
      touchY = ay
    elseif(ax <= 120 and ax >= 40 and ay <= 0) then
      ctouchX = ax
      ctouchY = ay
    end
    keepInside(prop)
    moveGun(gun, prop, cross)
    keepInside(cross)
  end
  
  local gameButton = pausePartition:propForPoint( buttonlayer:wndToWorld(x,y) )
  if gameButton then 
    if (gameButton.name == "pause") then
      loadMenuLayers()
      MOAISim.forceGarbageCollection()  
      gamestate = "pause"  
    end
  end
end

function upgradeInput(event, idx, x, y)
  local pickedProp = upgradePartition:propForPoint( upgradeLayer:wndToWorld(x,y) )
  if pickedProp then 
    if (pickedProp.name == "leaveUpgradeScreen") then
      loadMenuLayers()
    elseif (pickedProp.name == "upgradeItem") then
      for i = 1, table.getn(shipUpgradesList), 1 do
        local upgrade = shipUpgradesList[i]
        if pickedProp == upgrade:GetProp() then
          local deltaX, deltaY
          local propX, propY = pickedProp:getLoc()
          deltaX = 0 - propX
          deltaY = 10 - propY
           
          UpdateShipUpgradesPositions(deltaX, deltaY, i)
          textboxNameValue:setString(""..upgrade:GetName())
          textboxMetalValue:setString(""..upgrade:GetRequiredMetal())
          textboxPlasmaValue:setString(""..upgrade:GetRequiredPlasma())
          textboxTimeValue:setString(""..upgrade:GetRequiredTime())
            
          SetBuildButtonVisibility(upgrade)
        end
      end
    elseif (pickedProp.name == "buildUpgrade") then
      local upgrade = BuildShipUpgrade()
      SetBuildButtonVisibility(upgrade)
    end
  end
end

function eobInput(event, idx, x, y)
  local goToMenuButton = eobpartition:propForPoint( endweeklayer:wndToWorld(x,y) )
  if goToMenuButton then
    loadMenuLayers()
    gamestate = "pause"
  end
end

function baseInput(event, idx, x, y)
  local hitButton = partition:propForPoint( menuLayer:wndToWorld(x,y) )
  if hitButton then 
    if (hitButton.name == "playing") then
      thread:run(threadDuel)
        
      lastX, lastY = layer:wndToWorld(x, y*-1)
        
      loadFightLayers()
      gamestate = "playing"
      boolean = WAIT
    elseif (hitButton.name == "shipUpgrades") then
      loadShipUpgradesLayers()
    end
  end
end

function keepInside(p)
  local x, y = p:getLoc()
  if(y>70) then y = 70 end
  if(y<-80) then y = -80 end
  p:setLoc(x,y)
end

function SwipingInUpgradeMenu(x, y, eventType)
  local worldX, worldY = upgradeLayer:wndToWorld(x, y*-1)
  
  if eventType == MOAITouchSensor.TOUCH_DOWN then
    swipeStartX = worldX
    swipeStartY = worldY
    swipeLastX = worldX
    swipeLastY = worldY
  elseif eventType == MOAITouchSensor.TOUCH_MOVE then
    local deltaStartX = math.abs(worldX - swipeStartX)
    
    if(deltaStartX > minSwipeDistance) then
      local deltaX = worldX - swipeLastX
      
      UpdateShipUpgradesPositionsBySwipe(deltaX, 0)
    end
    
    swipeLastX = worldX
    swipeLastY = worldY
  elseif eventType == MOAITouchSensor.TOUCH_UP then
    SnapToClosestUpgrade()
  end
end

if MOAIInputMgr.device.pointer then
  MOAIInputMgr.device.mouseLeft:setCallback (mouseInput)
  MOAIInputMgr.device.pointer:setCallback (mouseMove)
else
  MOAIInputMgr.device.touch:setCallback (touchInput)
end
