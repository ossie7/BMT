function cl()
  local layer = MOAILayer2D.new()
  layer:setViewport(viewport)
  return layer
end

function cp(layer)
  local partition = MOAIPartition.new()
  layer:setPartition(partition)
  return partition
end

function cprop(sprite, x, y, scale)
  scale = scale or 1
  local prop = MOAIProp2D.new()
	prop:setDeck(sprite)
	prop:setLoc(x, y)
  prop:setBlendMode( MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA )
  prop:setScl(scale)
  return prop
end

function initLayers()
  universeLayer  = cl() --Universe background
  layer          = cl() --Ship
  spartition     = cp(layer)
  clayer         = cl() --Crosshair/gun
  buttonlayer    = cl() --Menu buttons
  pausePartition = cp(buttonlayer)
  textLayer      = cl() --Text
  menuLayer      = cl() --Menu
  guiLayer       = cl() --GUI
  guiButtonLayer = cl() --GUI buttons
  guiPartition   = cp(guiButtonLayer)
  baselayer      = cl() --Base background
  basebarlayer   = cl() --Warzone bars
  blayer         = cl() --Bullets
  bpartition     = cp(blayer)
  elayer         = cl() --Enemy bullets
  epartition     = cp(elayer)
  elayer2        = cl() --Right enemies
  epartition2    = cp(elayer2)
  eblayer        = cl() --Enemy bullets
  ebpartition    = cp(eblayer)
  ebrlayer       = cl() --Reflected enemy bullets
  ebrpartition   = cp(ebrlayer)
  exlayer        = cl() --Explosions
  endweeklayer   = cl() --Reward screen
  eobpartition   = cp(endweeklayer)
  upgradeback    = cl() --Upgrade background
  upgradeLayer   = cl() --UpgradeItem layer
  upgradePartition = cp(upgradeLayer)
  popupLayer       = cl() -- Popup background
  popupButtonLayer = cl() -- Popup button
  popupPartition   = cp(popupButtonLayer)
  popupTextLayer   = cl() -- Popup text
  
  --loadMenuLayers()
  loadSplashLayers()
end

function loadFightLayers()
  clearLayers()
  MOAIRenderMgr.pushRenderPass(universeLayer)
  MOAIRenderMgr.pushRenderPass(eblayer)
  MOAIRenderMgr.pushRenderPass(ebrlayer)
	MOAIRenderMgr.pushRenderPass(elayer)
  MOAIRenderMgr.pushRenderPass(elayer2)
  MOAIRenderMgr.pushRenderPass(exlayer)
  MOAIRenderMgr.pushRenderPass(blayer)
  MOAIRenderMgr.pushRenderPass(clayer)
	MOAIRenderMgr.pushRenderPass(layer)
  MOAIRenderMgr.pushRenderPass(textLayer)
  MOAIRenderMgr.pushRenderPass(guiLayer)
  MOAIRenderMgr.pushRenderPass(guiButtonLayer)
  
  backgroundSound(battleMusic)
  
  currentWave = 1
  save_userdata()
  battleDone = 0
  
  upgradee = stationUpgradesList[1]
  local winDate
  if(userdata.stationBuild and userdata.warzone == 5) then
    local daysBuild = userdata.daysBuild + 1
    userdata.daysBuild = daysBuild
    save_userdata()
  end
  
  if(userdata.daysBuild == upgradee.requiredTime) then
    SetupNewUserdata()
    clearUpgrades()
    save_userdata()
    addPopup("You won!", "Congratulations, you managed to\n build the station.\n You completed the beta! ^^", "OK", "loadMenuLayers")
  end
  
  propExplosion = MOAIProp2D.new()
  propExplosion:setDeck(tileLib)

  curve = MOAIAnimCurve.new()
  curve:reserveKeys(8)

  for i=1, 8, 1 do
    -- index, time, hoeveelste plaatje
    curve:setKey(i, 0.05 * i, i)
    
  end
  
  propButton = cprop(spritePauseButton, -140, -75)
  propButton.name = "pause"
  
  toggleButton = cprop(guiAutoSprite, 0, bottomborder)
  toggleButton.name = "gunToggle"
  
  guiPartition:insertProp(toggleButton)
	guiPartition:insertProp(propButton)
  
  gamestate = "playing"
end

function loadMenuLayers()
  clearLayers()
  MOAIRenderMgr.pushRenderPass(baselayer)
  MOAIRenderMgr.pushRenderPass(basebarlayer)
  MOAIRenderMgr.pushRenderPass(menuLayer)
  
  backgroundSound(menuMusic)
	
  basebackprop = cprop(basesprite, 0, 0)
  baselayer:insertProp(basebackprop)
  
  -- start intro conversation
  if(userdata.isFirstTime and popupActive == false) then
    queuePopup({
      Popup.new("Captain", "Welcome, I'm the captain.\n Tap me on the base screen\n to start.", "Next", nil, captainSprite),
      Popup.new("Captain", "Two planets are at war,\n their fleets are at warzone 5.\n Try to keep them there.", "Next", nil,captainSprite),
      Popup.new("Captain", "Meanwhile, you must build\n the station in order\n for trade to start. ", "Next", nil ,captainSprite),
      Popup.new("Architect", "Hello, I am the architect.\n I can build the station,\n but you will need \n more experience for that.", "Next", nil, architectSprite),
      Popup.new("Architect", "Speak to me later.", "OK", nil, architectSprite),
    })
  userdata.isFirstTime = false
  save_userdata()
  end
        
  
  engineerprop = cprop(engineer, -65,-50)
  engineerprop.name = "shipUpgrades"
  architectprop = cprop(architect, 65,-40)
  architectprop.name = "stationUpgrades"
  captainprop = cprop(captain, 0,-15)
  captainprop.name = "playing"
  textboxTurn = CreateTextBox(-120, 82, 100, 15, upgradeMenuStyle, "Turn "..userdata.turn)
  textboxTurn:setAlignment(MOAITextBox.CENTER_JUSTIFY, MOAITextBox.CENTER_JUSTIFY)
  ShowPlayerResources()
  
  loadBaseBars()

	partition = cp(menuLayer)
  partition:insertProp(propMetal)
  partition:insertProp(propPlasma)
  partition:insertProp(textboxTurn)
  partition:insertProp(textboxMetalAmount)
  partition:insertProp(textboxEnergyAmount)
  partition:insertProp(captainprop)
  partition:insertProp(architectprop)
  if(userdata.showEngineer) then
    partition:insertProp(engineerprop)
  end

  
	gamestate = "pause"
end

function loadSplashLayers()
  clearLayers()
  MOAIRenderMgr.pushRenderPass(baselayer)
	
  backgroundSound(menuMusic)

  background = cprop(universeSprite, 0, 0)
  splashLogo = cprop(splashLogo, 0, 20)
  textbox = CreateTextBox(0, -60, 200, 30, style15, "Touch to Continue")
  textbox:setAlignment(MOAITextBox.CENTER_JUSTIFY, MOAITextBox.CENTER_JUSTIFY)
  
  baselayer:insertProp(background)
  baselayer:insertProp(splashLogo)
  baselayer:insertProp(textbox)
  
	gamestate = "splash"
end

function loadBaseBars()
  
  local left = ((userdata.warzone - 0.5) / 9) * 212
  local right = ((9.5 - userdata.warzone) / 9) * -212
  local fist = ((userdata.warzone - 5) / 9 ) * 212

  --[[
  if(leftWon ~= nil) then
    --leftOld = ((userdata.warzone - 0.5) / 9) * 212
    --rightOld = ((9.5 - userdata.warzone) / 9) * -212
  else
    leftOld = ((userdata.warzone - 0.5) / 9) * 212
    rightOld = (( 9.5 - userdata.warzone) / 9) * -212
    fistOld = ((userdata.warzone - 5) / 9) * 212
  end--]]
  --leftWon = false
   if(leftWon ~= nil) then
     if(leftWon) then
       --print("DDDDDDDDDDDDDDDDDDDDDDDDDDDDD")
      leftOld = ((userdata.warzone - 1) / 9) * 212
      fistOld = ((userdata.warzone - 6) / 9) * 212
      rightOld = ((10.85 - userdata.warzone) / 9) * -212
    elseif(leftWon == false) then
      leftOld = (((userdata.warzone - 1) / 9) * 212) + 40
      fistOld = (((userdata.warzone - 6) / 9) * 212) + 40
      rightOld = (((11 - userdata.warzone) / 9) * -212)  +50
      print("DDDDDDDDDDDDDDDDDDDDDDDDDDDDD")
    end
  else
    fistOld = fist
    leftOld = left
    rightOld = right 
  end
  
  lbprop = cprop(lbsprite, -128, 38)
  basebarlayer:insertProp(lbprop)
  lbsprite:setRect(0,0,leftOld,-11)
  
  rbprop = cprop(rbsprite, 128,38)
  basebarlayer:insertProp(rbprop)
  rbsprite:setRect(rightOld,-11,0,0)
  
  lfprop = cprop(lfsprite, fistOld, 33)
  basebarlayer:insertProp(lfprop)
  
  rfprop = cprop(rfsprite, fistOld, 33)
  basebarlayer:insertProp(rfprop)
  
  wzprop = cprop(wzSprite, 0, 0)
  basebarlayer:insertProp(wzprop)
  
  if(leftWon == false) then
        --left = left - 30 
      end
  
  local fistTimer = MOAITimer.new()
  fistTimer:setMode(MOAITimer.LOOP)
  fistTimer:setSpan(0.1)
  fistTimer:setListener(MOAITimer.EVENT_TIMER_LOOP ,
    function()
      
      local distance = left - leftOld
      if(math.floor(leftOld) ~= math.floor(left)) then
        if(leftWon) then
            leftOld = leftOld + 1
            lbsprite:setRect(0,0,leftOld,-11)

            rightOld = rightOld + 1
            rbsprite:setRect(rightOld,-11,0,0)
          elseif(leftWon == false) then
            leftOld = leftOld - 1
            lbsprite:setRect(0,0,leftOld,-11)
            --print("dfsf"..leftOld.."ddfsfds"..left)
            rightOld = rightOld - 1
            rbsprite:setRect(rightOld,-11,0,0)
          end
      else
        fistTimer:stop()
      end
      
    end)
  fistTimer:start()

  if(leftWon ~= nil) then
    if(leftWon) then
    lfprop:moveLoc(fist-fistOld, 0,3)
    rfprop:moveLoc(fist-fistOld, 0,3)
  else
    lfprop:moveLoc((fist-fistOld), 0,3)
    rfprop:moveLoc((fist-fistOld), 0,3)
  end
  end
end

function loadUpgradesLayers(upgradeScreenType)
  clearLayers()
  MOAIRenderMgr.pushRenderPass(upgradeback)
  MOAIRenderMgr.pushRenderPass(upgradeLayer)
  MOAIRenderMgr.pushRenderPass(textLayer)
  
  backgroundSound(menuMusic)
  
  upgradeType = upgradeScreenType
  ShowPlayerResources()
  LoadUpgradesList()
   
  if upgradeType == "ship" then
    propUpgradeBackground = cprop(shipUpgradeScreenSprite, 0, 0)
    chatboxProp = cprop(chatboxShipSprite, -2, 50)
    textboxChatBox = CreateTextBox(-2, 54, 132, 48, chatboxstyle, "Welcome to my shop. \n Select the item you want.")
  elseif upgradeType == "station" then
    propUpgradeBackground = cprop(stationUpgradeScreenSprite, 0, 0)
    chatboxProp = cprop(chatboxStationSprite, 2, 50)
    textboxChatBox = CreateTextBox(2, 54, 132, 48, chatboxstyle, "Welcome to my office. \n Select the module you want.")
    if(userdata.firstTimeStation and userdata.turn > 4 and userdata.showEngineer) then
     queuePopup({
      Popup.new("Architect", "Welcome to my office!\n You can buy modules for the station.", "Next", nil, architectSprite),
      Popup.new("Architect", "You need enough resources and \n each module needs some time to be built.", "Next", nil,architectSprite),
      Popup.new("Architect", "The first part needs 5 days to be built", "Next",          nil ,architectSprite),
      Popup.new("Architect", "Because this is a beta version this is the only module for now.\n Build it and stay in warzone 5 for 2 turns.", "Next", nil, architectSprite),
      Popup.new("Architect", "After that... \n You completed the beta!",            "OK"          , nil, architectSprite),
    })
      userdata.firstTimeStation = false
      save_userdata()
    end
  end
  propBackButton = cprop(backButtonSprite, -132, -62)
  propBuildButton = cprop(buildButtonSprite, 133, -62)
  propPlayerShip = cprop(playerSingle, 0, 5, 2)
  
  upgradePartition:insertProp(propBuildButton)
  upgradePartition:insertProp(propBackButton)
  
  upgradeback:insertProp(propUpgradeBackground)
  upgradeback:insertProp(propMetal)
  upgradeback:insertProp(propPlasma)
  upgradeback:insertProp(textboxMetalAmount)
  upgradeback:insertProp(textboxEnergyAmount)
  upgradeback:insertProp(chatboxProp)

  
  if upgradeType == "ship" then
    upgradeback:insertProp(propPlayerShip)
  end
  
  --Value textboxes
  local textboxY = -62
  textboxMetalValue = CreateTextBox(-75, textboxY, 64, 15, upgradeMenuStyle, "")
  textboxMetalValue:setAlignment(MOAITextBox.CENTER_JUSTIFY, MOAITextBox.CENTER_JUSTIFY)
  textboxPlasmaValue = CreateTextBox(73, textboxY, 64, 15, upgradeMenuStyle, "")
  textboxPlasmaValue:setAlignment(MOAITextBox.CENTER_JUSTIFY, MOAITextBox.CENTER_JUSTIFY)
  textboxTimeValue = CreateTextBox(-1, textboxY, 64, 15, upgradeMenuStyle, "")
  textboxTimeValue:setAlignment(MOAITextBox.CENTER_JUSTIFY, MOAITextBox.CENTER_JUSTIFY)
  textboxNameValue = CreateTextBox(0, -30, 160, 40, upgradeMenuStyle, "")
  textboxNameValue:setAlignment(MOAITextBox.CENTER_JUSTIFY, MOAITextBox.CENTER_JUSTIFY)
  textboxChatBox:setAlignment(MOAITextBox.CENTER_JUSTIFY, MOAITextBox.CENTER_JUSTIFY)
  
  textLayer:insertProp(textboxMetalValue)
  textLayer:insertProp(textboxPlasmaValue)
  textLayer:insertProp(textboxTimeValue)
  textLayer:insertProp(textboxNameValue)
  textLayer:insertProp(textboxChatBox)
  textLayer:setPriority(1001)
  
  local upgrade = currentUpgradesList[1]
  SetBuildButtonVisibility(upgrade)
  SetUpgradeScreenInfo(upgrade)
  
  propBackButton.name = "leaveUpgradeScreen"
  propBuildButton.name = "buildUpgrade"
  gamestate = "upgrading"
end

function ShowPlayerResources()
  propMetal  = cprop(metalSprite,  78,  80)
  propPlasma = cprop(plasmaSprite, 120, 80)
  
  textboxMetalAmount = CreateTextBox(98, 82, 35, 15, upgradeMenuStyle, ""..userdata.metal)
  textboxMetalAmount:setAlignment(MOAITextBox.CENTER_JUSTIFY, MOAITextBox.CENTER_JUSTIFY)
  textboxEnergyAmount = CreateTextBox(140, 82, 35, 15, upgradeMenuStyle, ""..userdata.plasma)
  textboxEnergyAmount:setAlignment(MOAITextBox.CENTER_JUSTIFY, MOAITextBox.CENTER_JUSTIFY)
end

function clearLayers()
  universeLayer:clear()
  layer:clear()
  clayer:clear()
  buttonlayer:clear()
  textLayer:clear()
  menuLayer:clear()
  upgradeLayer:clear()
  guiLayer:clear()
  guiButtonLayer:clear()
  baselayer:clear()
  basebarlayer:clear()
  blayer:clear()
  elayer:clear()
  elayer2:clear()
  eblayer:clear()
  ebrlayer:clear()
  endweeklayer:clear()
  upgradeback:clear()
  exlayer:clear()
  eobpartition:clear()
  MOAISim.forceGarbageCollection()
end
