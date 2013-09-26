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
  
  loadMenuLayers()
end

function loadFightLayers()
  currentWave = 1
  week = week + 1
  battleDone = 0
  
  clearLayers()
  MOAIRenderMgr.pushRenderPass(universeLayer)
  MOAIRenderMgr.pushRenderPass(buttonlayer)
  MOAIRenderMgr.pushRenderPass(eblayer)
  MOAIRenderMgr.pushRenderPass(ebrlayer)
	MOAIRenderMgr.pushRenderPass(elayer)
  MOAIRenderMgr.pushRenderPass(elayer2)
	MOAIRenderMgr.pushRenderPass(layer)
  MOAIRenderMgr.pushRenderPass(blayer)
  MOAIRenderMgr.pushRenderPass(clayer)
  MOAIRenderMgr.pushRenderPass(textLayer)
  MOAIRenderMgr.pushRenderPass(barlayer)
  
  texturePause = MOAIImage.new()
  texturePause:load("resources/wm_pause.png")
  
  spritePauseButton = MOAIGfxQuad2D.new()
	spritePauseButton:setTexture(texturePause)
	spritePauseButton:setRect(-8, -8, 8, 8);
  
  propButton = MOAIProp2D.new()
	propButton:setDeck(spritePauseButton)
	propButton:setLoc(-130,-70)
  propButton:setBlendMode( MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA )
  propButton:setPriority(1000)
  
  buttonlayer:insertProp(propButton)
  buttonlayer:setPriority(1000)
  
  textboxGameMode = MOAITextBox.new()
	textboxGameMode:setStyle(style)
	textboxGameMode:setString("Coins ="..coins)
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
	pausePartition:insertProp(propButton)
	buttonlayer:setPartition(pausePartition)
  gamestate = "playing"
  propButton.name = "pause"
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
   
  MOAIRenderMgr.pushRenderPass(upgradeLayer)
  MOAIRenderMgr.pushRenderPass(textLayer)
  
  texturePlay = MOAIImage.new()
  texturePlay:load("resources/play_button.png")
  
	spriteBackButton = MOAIGfxQuad2D.new()
	spriteBackButton:setTexture(texturePlay)
	spriteBackButton:setRect(-32, -32, 32, 32);
  
  propBackButton = MOAIProp2D.new()
	propBackButton:setDeck(spriteBackButton)
	propBackButton:setLoc(-130,-60)
  propBackButton:setBlendMode( MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA )
  
  propBuildButton = MOAIProp2D.new()
	propBuildButton:setDeck(spriteBackButton)
	propBuildButton:setLoc(130,-60)
  propBuildButton:setBlendMode( MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA )
  
  propPlayerShip = MOAIProp2D.new()
	propPlayerShip:setDeck(sprite)
	propPlayerShip:setLoc(0, 10)
  propPlayerShip:setScl(3)
  propPlayerShip:setBlendMode( MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA )
  
  upgradePartition = MOAIPartition.new()
	upgradePartition:insertProp(propBackButton)
  upgradePartition:insertProp(propBuildButton)
	upgradeLayer:setPartition(upgradePartition)
  upgradeLayer:insertProp(propPlayerShip)
  
  LoadShipUpgradesList()
  
  -- name textboxes
  textboxMetal = CreateTextBox(0, -80, 100, 100, upgradeMenuStyle, "Metal: ")
  textboxTech = CreateTextBox(0, -90, 100, 100, upgradeMenuStyle, "Tech: ")
  textboxTime = CreateTextBox(0, -100, 100, 100, upgradeMenuStyle, "Time: ")
  
  --Value textboxes
  textboxMetalValue = CreateTextBox(90, -80, 100, 100, upgradeMenuStyle, "")
  textboxTechValue = CreateTextBox(90, -90, 100, 100, upgradeMenuStyle, "")
  textboxTimeValue = CreateTextBox(90, -100, 100, 100, upgradeMenuStyle, "")
  textboxNameValue = CreateTextBox(0, 70, 160, 40, upgradeMenuStyle, "")
  textboxNameValue:setAlignment(MOAITextBox.CENTER_JUSTIFY, MOAITextBox.CENTER_JUSTIFY)
  
	textLayer:insertProp(textboxMetal)
  textLayer:insertProp(textboxTech)
  textLayer:insertProp(textboxTime)
  textLayer:insertProp(textboxMetalValue)
  textLayer:insertProp(textboxTechValue)
  textLayer:insertProp(textboxTimeValue)
  textLayer:insertProp(textboxNameValue)
  textLayer:setPriority(1001)
  
  local upgrade = shipUpgradesList[1]
  SetBuildButtonVisibility(upgrade)
  textboxNameValue:setString(""..upgrade:GetName())
  textboxMetalValue:setString(""..upgrade:GetRequiredMetal())
  textboxTechValue:setString(""..upgrade:GetRequiredTech())
  textboxTimeValue:setString(""..upgrade:GetRequiredTime())
  
  propBackButton.name = "leaveUpgradeScreen"
  propBuildButton.name = "buildUpgrade"
  gamestate = "upgrading"
end

function clearLayers()
  universeLayer:clear()
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
  MOAISim.forceGarbageCollection()
end
