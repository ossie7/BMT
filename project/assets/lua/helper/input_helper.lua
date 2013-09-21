
local lastX = 0
local lastY = 0
local clastX = 0
local clastY = 0

local touchX = 0
local touchY = 0
local ctouchX = 0
local ctouchY = 0

function onTouch(x,y)
  if(gamestate == "pause") then
    local hitButton = partition:propForPoint( menuLayer:wndToWorld(x,y) )
    if hitButton then 
      if (hitButton.name == "playing") then
        thread:run(threadDuel)
          
        lastX, lastY = layer:wndToWorld(x, y*-1)
          
        loadFightLayers()
        gamestate = "playing"
        boolean = WAIT
        playInput()
      elseif (hitButton.name == "shipUpgrades") then
        loadShipUpgradesLayers()
      end
    end
  end
  
  if(gamestate == "upgrading") then
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
            textboxLeftFactionResourceValue:setString(""..upgrade:GetRequiredResourcesLeftFaction())
            textboxRightFactionResourceValue:setString(""..upgrade:GetRequiredResourcesRightFaction())
            textboxTimeValue:setString(""..upgrade:GetRequiredTime())
          end
        end
      end
    end
  end
   
  if(gamestate == "playing") then
    local gameButton = pausePartition:propForPoint( buttonlayer:wndToWorld(x,y) )
    if gameButton then 
      if (gameButton.name == "pause") then
        loadMenuLayers()
        MOAISim.forceGarbageCollection()  
        gamestate = "pause"  
        end
     end
   end
end

function onMouseLeftEvent ( down )
    if ( down ) then
        drag = true
        onTouch(MOAIInputMgr.device.pointer:getLoc())
    else
        drag = false
    end
end

function onMove ( x, y )
  ax, ay = layer:wndToWorld(x, y*-1)
  if ( drag and ax <= -100) then
    local deltaY = (ay - lastY) * -1
    prop:moveLoc (0, deltaY, 0, 0, MOAIEaseType.FLAT )
  elseif(drag and ax >= 100) then
    local deltaY = (ay - clastY) * -1
    cross:moveLoc (0, deltaY, 0, 0, MOAIEaseType.FLAT )
  end
  if(ax <= -100) then
    lastX = ax
    lastY = ay
  elseif(ax >= 100) then
    clastX = ax
    clastY = ay
  end
  moveGun(gun, prop, cross)
end

function touchMove( x, y, event)
  local ax, ay = layer:wndToWorld(x, y*-1)
  if (event == 1 and ax <= -100) then
  local deltaX = 0
    local deltaY = (ay - touchY) * -1
    prop:moveLoc ( deltaX, deltaY, 0, 0, MOAIEaseType.FLAT )
  elseif(event == 1 and ax >= 100) then
    local deltaY = (ay - ctouchY) * -1
    cross:moveLoc ( deltaX, deltaY, 0, 0, MOAIEaseType.FLAT )
  end
  if(ax <= -100) then
    touchX = ax
    touchY = ay
  elseif(ax >= 100) then
    ctouchX = ax
    ctouchY = ay
  end
  moveGun(gun, prop, cross)
end

if MOAIInputMgr.device.pointer then
  MOAIInputMgr.device.mouseLeft:setCallback ( onMouseLeftEvent )
else
  MOAIInputMgr.device.touch:setCallback (
    function ( eventType, idx, x, y, tapCount )
      onTouch(x, y)
      touchMove ( x, y, eventType )
    end
    )
end

function playInput()
  if MOAIInputMgr.device.pointer then
    MOAIInputMgr.device.mouseLeft:setCallback ( onMouseLeftEvent )
    if(gamestate == "playing") then
      MOAIInputMgr.device.pointer:setCallback ( onMove )
    end
  end  
end