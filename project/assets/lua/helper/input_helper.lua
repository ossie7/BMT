touchX = 0
touchY = 0
ctouchX = 0
ctouchY = 0

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
  if(popupActive and event == MOAITouchSensor.TOUCH_DOWN) then
    local hit = popupPartition:propForPoint(popupButtonLayer:wndToWorld(x,y))
    if(hit) then
      popupClicked(hit)
    end
  else
    if(gamestate == "splash") then
      splashInput(event, idx, x, y)
    elseif(gamestate == "playing") then
      playInput(event, idx, x, y)
    elseif(gamestate == "upgrading") then
      upgradeInput(event, idx, x, y)
    elseif(gamestate == "pause") then
      baseInput(event, idx, x, y)
    end
  end
end

function splashInput(event, idx, x, y)
  if(event == MOAITouchSensor.TOUCH_DOWN) then
    loadMenuLayers()
  end
end

function playInput(event, idx, x, y)
  local ax, ay = layer:wndToWorld(x, y)
  
  if prop ~= nil then
    if (event == 1 and ax >= -120 and ax <= -40 and ay <= -20) then
      shipDeltaY = (ay - touchY) * 3
      prop:moveLoc ( 0, shipDeltaY, 0, 0, MOAIEaseType.FLAT )
    elseif(event == 1 and ax <= 120 and ax >= 40 and ay <= -20) then
      gunDeltaY = (ay - ctouchY) * 3
      cross:moveLoc ( 0, gunDeltaY, 0, 0, MOAIEaseType.FLAT )
    end
    if(ax >= -120 and ax <= -40 and ay <= -20) then
      touchX = ax
      touchY = ay
    elseif(ax <= 120 and ax >= 40 and ay <= -20) then
      ctouchX = ax
      ctouchY = ay
    end
    keepInside(prop)
    if(userdata.mission ~= "chased") then
      moveGun(gun, prop, cross)
    end
    keepInside(cross)
  end
  
  -- Button logic, only on mouse/touch down
  if(event == MOAITouchSensor.TOUCH_DOWN) then
    local gameButton = guiPartition:propForPoint( guiButtonLayer:wndToWorld(x,y) )
    local powerButton = spartition:propForPoint(layer:wndToWorld(x, y))
    
    if powerButton then
      if (powerButton.name == "ship") then
        shipHit()
      elseif(powerButton.name == "gun") then
        gunHit()
      end
    end
    if gameButton then
      if (gameButton.name == "pause") then
        addPausePopup()
      elseif(gameButton.name == "gunToggle") then
        gunActive = not gunActive
        if(gunActive) then
          gameButton:setDeck(guiAutoSprite)
        else
          gameButton:setDeck(guiRegenSprite)
        end
      end
    end
  end
end

function upgradeInput(event, idx, x, y)
  local pickedProp = upgradePartition:propForPoint( upgradeLayer:wndToWorld(x,y) )
  if pickedProp and event == MOAITouchSensor.TOUCH_DOWN then 
    if (pickedProp.name == "leaveUpgradeScreen") then
      if upgradeType == "ship" then
        shipUpgradesList = currentUpgradesList
      elseif upgradeType == "station" then
        stationUpgradesList = currentUpgradesList
      end
      
      loadMenuLayers()
    elseif (pickedProp.name == "upgradeItem") then
      for i = 1, table.getn(currentUpgradesList), 1 do
        local upgrade = currentUpgradesList[i]
        if pickedProp == upgrade:GetProp() then
          local deltaX, deltaY
          local propX, propY = pickedProp:getLoc()
          deltaX = 0 - propX
          deltaY = 5 - propY
           
          UpdateUpgradesPositions(deltaX, deltaY, i)
          SetUpgradeScreenInfo(upgrade)
          if(upgradeType == "ship") then
            textboxChatBox:setString("This is the "..upgrade.name..". \n It improves your damage.")
          elseif(upgradeType == "station") then
            -- add upgrade time
            textboxChatBox:setString("This is the "..upgrade.name..".")
          end

          SetBuildButtonVisibility(upgrade)
        end
      end
    elseif (pickedProp.name == "buildUpgrade") then
      local upgrade = BuildUpgrade()
      SetBuildButtonVisibility(upgrade)
    end
  end
end

function baseInput(event, idx, x, y)
  if(popupActive == false) then
    if userdata.turn == 0 and userdata.seenFirstOverlay == false then
      addOverlay(overlay1, "Ok", nil)
      userdata.seenFirstOverlay = true
      save_userdata()
    else
      local hitButton = partition:propForPoint( menuLayer:wndToWorld(x,y) )
      if hitButton and event == MOAITouchSensor.TOUCH_DOWN then
        if (hitButton.name == "playing") then
          thread:run(threadDuel)
            
          lastX, lastY = layer:wndToWorld(x, y*-1)
            
          loadFightLayers()
          gamestate = "playing"
          boolean = WAIT
        elseif (hitButton.name == "shipUpgrades") then
          loadUpgradesLayers("ship")
        elseif (hitButton.name == "stationUpgrades") then
          if(userdata.turn < 5 and showEngineer ~= true) then
            addPopup("Architect", "You still need some more experience.\n Wait till turn 5.", "OK", nil, architectSprite)
          else
            loadUpgradesLayers("station")
          end
        end
      end
    end
  end
end

function keepInside(p)
  local x, y = p:getLoc()
  if(y>70) then y = 70 end
  if(y<-60) then y = -60 end
  p:setLoc(x,y)
end

if MOAIInputMgr.device.pointer then
  MOAIInputMgr.device.mouseLeft:setCallback (mouseInput)
  MOAIInputMgr.device.pointer:setCallback (mouseMove)
else
  MOAIInputMgr.device.touch:setCallback (touchInput)
end
