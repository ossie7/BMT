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

function initLayers()
  universeLayer = cl() --Universe background
  layer         = cl() --Ship
  clayer        = cl() --Crosshair/gun
  buttonlayer   = cl() --Menu buttons
  textLayer     = cl() --Text
  menuLayer     = cl() --Menu
  upgradeLayer  = cl() --Upgrade
  barlayer      = cl() --Fight progress bars
  baselayer     = cl() --Base background
  basebarlayer  = cl() --Warzone bars
  blayer        = cl() --Bullets
  bpartition    = cp(blayer)
  elayer        = cl() --Enemy bullets
  epartition    = cp(elayer)
  elayer2       = cl() --Right enemies
  epartition2   = cp(elayer2)
  eblayer       = cl() --Enemy bullets
  ebpartition   = cp(eblayer)
  ebrlayer      = cl() --Reflected enemy bullets
  ebrpartition  = cp(ebrlayer)
  exlayer       = cl() --Explosions
  ihlayer       = cl() --Input hint
  endweeklayer  = cl() --Reward screen
  eobpartition  = cp(endweeklayer)
  upgradeback   = cl() --Upgrade background
  
  loadMenuLayers()
end

function loadFightLayers()
  currentWave = 1
  week = week + 1
  battleDone = 0
  
  propExplosion = MOAIProp2D.new()
  propExplosion:setDeck(tileLib)

  curve = MOAIAnimCurve.new()
  curve:reserveKeys(8)

  for i=1, 8, 1 do
    -- index, time, hoeveelste plaatje
    curve:setKey(i, 0.05 * i, i)
    
  end

  clearLayers()
  MOAIRenderMgr.pushRenderPass(universeLayer)
  MOAIRenderMgr.pushRenderPass(ihlayer)
  MOAIRenderMgr.pushRenderPass(buttonlayer)
  MOAIRenderMgr.pushRenderPass(eblayer)
  MOAIRenderMgr.pushRenderPass(ebrlayer)
	MOAIRenderMgr.pushRenderPass(elayer)
  MOAIRenderMgr.pushRenderPass(elayer2)
  MOAIRenderMgr.pushRenderPass(exlayer)
	MOAIRenderMgr.pushRenderPass(layer)
  MOAIRenderMgr.pushRenderPass(blayer)
  MOAIRenderMgr.pushRenderPass(clayer)
  MOAIRenderMgr.pushRenderPass(textLayer)
  MOAIRenderMgr.pushRenderPass(barlayer)
  
  propButton = MOAIProp2D.new()
	propButton:setDeck(spritePauseButton)
	propButton:setLoc(-130,-70)
  propButton:setBlendMode( MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA )
  propButton.name = "pause"
  
  gtButton = MOAIProp2D.new()
	gtButton:setDeck(gtsprite)
	gtButton:setLoc(0,-70)
  gtButton:setBlendMode( MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA )
  gtButton.name = "gunToggle"
  
  textboxGameMode = MOAITextBox.new()
	textboxGameMode:setStyle(style)
	textboxGameMode:setString("Turn "..week)
	textboxGameMode:setRect(-50,-50,50,50)
  textboxGameMode:setLoc(-100,30)
	textboxGameMode:setYFlip ( true )
	textLayer:insertProp(textboxGameMode)
  textLayer:setPriority(1001)
  
  textboxHealth = MOAITextBox.new()
	textboxHealth:setStyle(style)
	textboxHealth:setString("Health ="..health)
	textboxHealth:setRect(-60,-50,60,50)
  textboxHealth:setLoc(100,30)
	textboxHealth:setYFlip ( true )
	textLayer:insertProp(textboxHealth)
    
  pausePartition = MOAIPartition.new()
  pausePartition:insertProp(gtButton)
	pausePartition:insertProp(propButton)
	buttonlayer:setPartition(pausePartition)
  gamestate = "playing"
  
  
  --Input Help - TEMP - BEGIN
  ihtexture = MOAIImage.new()
  ihtexture:load("resources/controls.png")
  
  ihsprite = MOAIGfxQuad2D.new()
	ihsprite:setTexture(ihtexture)
	ihsprite:setRect(0, 0, -80, -50)
  
  ihprop1 = MOAIProp2D.new()
	ihprop1:setDeck(ihsprite)
	ihprop1:setLoc(-40,-40)
  ihprop1:setBlendMode( MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA )
  ihlayer:insertProp(ihprop1)
  
  ihprop2 = MOAIProp2D.new()
	ihprop2:setDeck(ihsprite)
	ihprop2:setLoc(120,-40)
  ihprop2:setBlendMode( MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA )
  ihlayer:insertProp(ihprop2)

  --Input Help - TEMP - END
end

function loadMenuLayers()
  clearLayers()
  
  MOAIRenderMgr.pushRenderPass(baselayer)
  MOAIRenderMgr.pushRenderPass(basebarlayer)
  MOAIRenderMgr.pushRenderPass(menuLayer)
	
  basebackprop = MOAIProp2D.new()
	basebackprop:setDeck(basesprite)
	basebackprop:setLoc(0,0)
  basebackprop:setBlendMode( MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA )
  baselayer:insertProp(basebackprop)
  
  ShowPlayerResources()
  
  loadBaseBars()
	  
	propStartButton = MOAIProp2D.new()
	propStartButton:setDeck(warroomStartBattleSprite)
	propStartButton:setLoc(12, -15)
  propStartButton:setBlendMode( MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA )
  
  propShipUpgradesButton = MOAIProp2D.new()
	propShipUpgradesButton:setDeck(warroomShipUpgradeSprite)
	propShipUpgradesButton:setLoc(-65, -50)
  propShipUpgradesButton:setBlendMode( MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA )
  
  propStationUpgradesButton = MOAIProp2D.new()
	propStationUpgradesButton:setDeck(warroomStationUpgradeSprite)
	propStationUpgradesButton:setLoc(65, -38)
  propStationUpgradesButton:setBlendMode( MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA )

	partition = MOAIPartition.new()
	partition:insertProp(propStartButton)
  partition:insertProp(propShipUpgradesButton)
  partition:insertProp(propStationUpgradesButton)
  partition:insertProp(propMetal)
  partition:insertProp(propPlasma)
  partition:insertProp(textboxMetalAmount)
  partition:insertProp(textboxEnergyAmount)
  
	menuLayer:setPartition(partition)
	  
	gamestate = "pause"
	
	propStartButton.name = "playing"
  propShipUpgradesButton.name = "shipUpgrades"

end

function loadBaseBars()
  local left = ((userdata.warzone - 0.5) / 9) * 212
  local right = ((9.5 - userdata.warzone) / 9) * -212
  local fist = ((userdata.warzone - 5) / 9 ) * 212
  
  lbprop = MOAIProp2D.new()
	lbprop:setDeck(lbsprite)
	lbprop:setLoc(-128,38)
  lbprop:setBlendMode( MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA )
  basebarlayer:insertProp(lbprop)
  lbsprite:setRect(0,0,left,-11)
  
  rbprop = MOAIProp2D.new()
	rbprop:setDeck(rbsprite)
	rbprop:setLoc(128,38)
  rbprop:setBlendMode( MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA )
  basebarlayer:insertProp(rbprop)
  rbsprite:setRect(right,-11,0,0)
  
  lfprop = MOAIProp2D.new()
	lfprop:setDeck(lfsprite)
	lfprop:setLoc(fist,33)
  lfprop:setBlendMode( MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA )
  basebarlayer:insertProp(lfprop)
  
  rfprop = MOAIProp2D.new()
	rfprop:setDeck(rfsprite)
	rfprop:setLoc(fist,33)
  rfprop:setBlendMode( MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA )
  basebarlayer:insertProp(rfprop)
end

function loadShipUpgradesLayers()
  clearLayers()
  
  MOAIRenderMgr.pushRenderPass(upgradeback)
  MOAIRenderMgr.pushRenderPass(upgradeLayer)
  MOAIRenderMgr.pushRenderPass(textLayer)
  
  ShowPlayerResources()
    
  propUpgradeBackground = MOAIProp2D.new()
	propUpgradeBackground:setDeck(shipUpgradeScreenSprite)
	propUpgradeBackground:setLoc(0,0)
  propUpgradeBackground:setBlendMode( MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA )
  
  propBackButton = MOAIProp2D.new()
	propBackButton:setDeck(warroomButtonSprite)
	propBackButton:setLoc(-132, -62)
  propBackButton:setBlendMode( MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA )
  
  propBuildButton = MOAIProp2D.new()
	propBuildButton:setDeck(warroomButtonSprite)
	propBuildButton:setLoc(132, -62)
  propBuildButton:setBlendMode( MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA )
  
  propPlayerShip = MOAIProp2D.new()
	propPlayerShip:setDeck(sprite)
	propPlayerShip:setLoc(0, 10)
  propPlayerShip:setScl(3)
  propPlayerShip:setBlendMode( MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA )
  
  upgradePartition = MOAIPartition.new()
  upgradePartition:insertProp(propBuildButton)
  upgradePartition:insertProp(propBackButton)
  upgradeLayer:setPartition(upgradePartition)
  
  upgradeback:insertProp(propUpgradeBackground)
  upgradeback:insertProp(propMetal)
  upgradeback:insertProp(propPlasma)
  upgradeback:insertProp(textboxMetalAmount)
  upgradeback:insertProp(propPlayerShip)
  upgradeback:insertProp(textboxEnergyAmount)
  
  LoadShipUpgradesList()
  
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
  
  textLayer:insertProp(textboxMetalValue)
  textLayer:insertProp(textboxPlasmaValue)
  textLayer:insertProp(textboxTimeValue)
  textLayer:insertProp(textboxNameValue)
  textLayer:setPriority(1001)
  
  local upgrade = currentUpgradesList[1]
  SetBuildButtonVisibility(upgrade)
  textboxNameValue:setString(""..upgrade:GetName())
  textboxMetalValue:setString(""..upgrade:GetRequiredMetal())
  textboxPlasmaValue:setString(""..upgrade:GetRequiredPlasma())
  textboxTimeValue:setString(""..upgrade:GetRequiredTime())
  
  propBackButton.name = "leaveUpgradeScreen"
  propBuildButton.name = "buildUpgrade"
  upgradeType = "ship"
  gamestate = "upgrading"
end

function endOfBattle(winningTeam, loot)
  
  clearLayers()
  textureGoMenu = MOAIImage.new()
  textureGoMenu:load("resources/play_button.png")
  
  spriteGoMenu = MOAIGfxQuad2D.new()
	spriteGoMenu:setTexture(textureGoMenu)
	spriteGoMenu:setRect(-8, -8, 8, 8)
  
  propGoMenu = MOAIProp2D.new()
	propGoMenu:setDeck(spriteGoMenu)
	propGoMenu:setLoc(-130,-70)
  propGoMenu:setBlendMode( MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA )
  propGoMenu:setPriority(1000)
  propGoMenu.name = "button"
  
  --endweekLayer:insertProp(propButton)
  
  amountOfLoot = loot
  MOAIRenderMgr.pushRenderPass(endweeklayer)
  
  local teamText = ""
  if(winningTeam == 1) then
    teamText = "left"
  else
    teamText = "right"
  end
  
  if(textboxBattleResults ~= nil) then
    eobpartition:removeProp(textboxBattleResults)
  end
  textboxBattleResults = CreateTextBox(0, 0, 150, 100, upgradeMenuStyle, 
    "The " .. teamText .. " team has lost this battle, you gained "..amountOfLoot.." plasma")
  
  userdata.plasma = userdata.plasma + loot
  save_userdata()
  
  eobpartition:insertProp(textboxBattleResults)
	eobpartition:insertProp(propGoMenu)
  gamestate = "endOfBattle"
end

function ShowPlayerResources()
  propMetal = MOAIProp2D.new()
	propMetal:setDeck(metalSprite)
	propMetal:setLoc(78,80)
  propMetal:setBlendMode( MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA )
  
  propPlasma = MOAIProp2D.new()
	propPlasma:setDeck(plasmaSprite)
	propPlasma:setLoc(120,80)
  propPlasma:setBlendMode( MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA )
  
  textboxMetalAmount = CreateTextBox(98, 82, 35, 15, upgradeMenuStyle, ""..userdata.metal)
  textboxMetalAmount:setAlignment(MOAITextBox.CENTER_JUSTIFY, MOAITextBox.CENTER_JUSTIFY)
  textboxEnergyAmount = CreateTextBox(140, 82, 35, 15, upgradeMenuStyle, ""..userdata.plasma)
  textboxEnergyAmount:setAlignment(MOAITextBox.CENTER_JUSTIFY, MOAITextBox.CENTER_JUSTIFY)
end

function clearLayers()
  universeLayer:clear()
  ihlayer:clear()
  layer:clear()
  clayer:clear()
  buttonlayer:clear()
  textLayer:clear()
  menuLayer:clear()
  upgradeLayer:clear()
  barlayer:clear()
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

