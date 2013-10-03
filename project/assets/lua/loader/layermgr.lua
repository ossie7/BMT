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
  
  loadMenuLayers()
end

function loadFightLayers()
  clearLayers()
  MOAIRenderMgr.pushRenderPass(universeLayer)
  MOAIRenderMgr.pushRenderPass(eblayer)
  MOAIRenderMgr.pushRenderPass(ebrlayer)
	MOAIRenderMgr.pushRenderPass(elayer)
  MOAIRenderMgr.pushRenderPass(elayer2)
  MOAIRenderMgr.pushRenderPass(exlayer)
	MOAIRenderMgr.pushRenderPass(layer)
  MOAIRenderMgr.pushRenderPass(blayer)
  MOAIRenderMgr.pushRenderPass(clayer)
  MOAIRenderMgr.pushRenderPass(textLayer)
  MOAIRenderMgr.pushRenderPass(guiLayer)
  MOAIRenderMgr.pushRenderPass(guiButtonLayer)
  
  backgroundSound(battleMusic)
  
  currentWave = 1
  userdata.turn = userdata.turn + 1
  save_userdata()
  battleDone = 0
  
  upgradee = stationUpgradesList[1]
  local winDate
  if(userdata.stationBuild and userdata.warzone == 5) then
    daysBuild = daysBuild + 1
    userdata.daysBuild = daysBuild
    save_userdata()
  end

  print("current week "..week)
  if(winDate ~= nil) then
    print("timeeeeee "..winDate)
  end
  
  if(userdata.daysBuild == upgradee.requiredTime) then
      Popup.new("You won!", "Congratulations, you managed to\n build the station.", "OK", nil)
  end
  
  
  propExplosion = MOAIProp2D.new()
  propExplosion:setDeck(tileLib)

  curve = MOAIAnimCurve.new()
  curve:reserveKeys(8)

  for i=1, 8, 1 do
    -- index, time, hoeveelste plaatje
    curve:setKey(i, 0.05 * i, i)
    
  end
  
  propButton = cprop(spritePauseButton, -130, -70)
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
  
  engineerprop = cprop(engineer, -65,-50)
  engineerprop.name = "shipUpgrades"
  architectprop = cprop(architect, 65,-40)
  architectprop.name = "stationUpgrades"
  captainprop = cprop(captain, 0,-15)
  captainprop.name = "playing"
  
  ShowPlayerResources()
  
  loadBaseBars()

	partition = cp(menuLayer)
  partition:insertProp(propMetal)
  partition:insertProp(propPlasma)
  partition:insertProp(textboxMetalAmount)
  partition:insertProp(textboxEnergyAmount)
  partition:insertProp(captainprop)
  if(userdata.showEngineer) then
    partition:insertProp(architectprop)
    partition:insertProp(engineerprop)
  end

  
	gamestate = "pause"
end

function loadBaseBars()
  local left = ((userdata.warzone - 0.5) / 9) * 212
  local right = ((9.5 - userdata.warzone) / 9) * -212
  local fist = ((userdata.warzone - 5) / 9 ) * 212
  
  lbprop = cprop(lbsprite, -128, 38)
  basebarlayer:insertProp(lbprop)
  lbsprite:setRect(0,0,left,-11)
  
  rbprop = cprop(rbsprite, 128,38)
  basebarlayer:insertProp(rbprop)
  rbsprite:setRect(right,-11,0,0)
  
  lfprop = cprop(lfsprite, fist, 33)
  basebarlayer:insertProp(lfprop)
  
  rfprop = cprop(rfsprite, fist, 33)
  basebarlayer:insertProp(rfprop)
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
    chatboxProp = cprop(chatboxShipSprite, 20, 50)
    textboxChatBox = CreateTextBox(20, 50, 132, 48, chatboxstyle, "Welcome to my shop. \n Select the item you want.")
  elseif upgradeType == "station" then
    propUpgradeBackground = cprop(stationUpgradeScreenSprite, 0, 0)
    chatboxProp = cprop(chatboxStationSprite, 0, 50)
    textboxChatBox = CreateTextBox(0, 50, 132, 48, chatboxstyle, "Welcome to my shop. \n Select the item you want.")
  end
  propBackButton = cprop(warroomButtonSprite, -132, -62)
  propBuildButton = cprop(warroomButtonSprite, 132, -62)
  propPlayerShip = cprop(sprite, 0, 10, 3)
  
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
  textboxNameValue:setString(""..upgrade:GetName())
  textboxMetalValue:setString(""..upgrade:GetRequiredMetal())
  textboxPlasmaValue:setString(""..upgrade:GetRequiredPlasma())
  textboxTimeValue:setString(""..upgrade:GetRequiredTime())
  
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
