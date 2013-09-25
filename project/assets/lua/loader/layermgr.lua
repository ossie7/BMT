function initLayers()
  backgroundLayer1 = MOAILayer2D.new()
  backgroundLayer1:setViewport(viewport)

  backgroundLayer2 = MOAILayer2D.new()
  backgroundLayer2:setViewport(viewport)

  backlayer = MOAILayer2D.new()
  backlayer:setViewport(viewport)
  
  universeLayer = MOAILayer2D.new()
  universeLayer:setViewport(viewport)

  layer = MOAILayer2D.new()
  layer:setViewport(viewport)

  blayer = MOAILayer2D.new()
  blayer:setViewport(viewport)
  bpartition = MOAIPartition.new()
  blayer:setPartition(bpartition)
  -- enemies aan linkerkant
  elayer = MOAILayer2D.new()
  elayer:setViewport(viewport)
  
  epartition = MOAIPartition.new()
  elayer:setPartition(epartition)
  -- enemies aan rechterkant
  elayer2 = MOAILayer2D.new()
  elayer2:setViewport(viewport)
  
  epartition2 = MOAIPartition.new()
  elayer2:setPartition(epartition2)
  
  
  --enemy bullet
  eblayer = MOAILayer2D.new()
  eblayer:setViewport(viewport)

  ebpartition = MOAIPartition.new()
  eblayer:setPartition(ebpartition)
  
  --enemy bullet reflection
  ebrlayer = MOAILayer2D.new()
  ebrlayer:setViewport(viewport)
  
  ebrpartition = MOAIPartition.new()
  ebrlayer:setPartition(ebrpartition)
  
  clayer = MOAILayer2D.new()
  clayer:setViewport(viewport)

  buttonlayer = MOAILayer2D.new()
  buttonlayer:setViewport(viewport)

  textLayer = MOAILayer2D.new()
  textLayer:setViewport(viewport)

  menuLayer = MOAILayer2D.new()
  menuLayer:setViewport(viewport)
  
  --upgrade layers
  upgradeLayer = MOAILayer2D.new()
  upgradeLayer:setViewport(viewport)
  
  barlayer = MOAILayer2D.new()
  barlayer:setViewport(viewport)
  
  baselayer = MOAILayer2D.new()
  baselayer:setViewport(viewport)
  
  basebarlayer = MOAILayer2D.new()
  basebarlayer:setViewport(viewport)
  
  loadMenuLayers()
end

function loadFightLayers()
  currentWave = 1
  week = week + 1
  
  clearLayers()
  MOAIRenderMgr.pushRenderPass(backgroundLayer1)
  MOAIRenderMgr.pushRenderPass(backgroundLayer2)
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
  
	texturePlay = MOAIImage.new()
  texturePlay:load("resources/play_button.png")
  
	spriteStartButton = MOAIGfxQuad2D.new()
	spriteStartButton:setTexture(texturePlay)
	spriteStartButton:setRect(-32, -32, 32, 32);
	  
	propStartButton = MOAIProp2D.new()
	propStartButton:setDeck(spriteStartButton)
	propStartButton:setLoc(0,-50)
  propStartButton:setBlendMode( MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA )
  
  propShipUpgradesButton = MOAIProp2D.new()
	propShipUpgradesButton:setDeck(spriteStartButton)
	propShipUpgradesButton:setLoc(-94,-50)
  propShipUpgradesButton:setBlendMode( MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA )
  
  propStationUpgradesButton = MOAIProp2D.new()
	propStationUpgradesButton:setDeck(spriteStartButton)
	propStationUpgradesButton:setLoc(94,-50)
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
  textboxLeftFactionResource = CreateTextBox(0, -80, 100, 100, upgradeMenuStyle, "LFRes: ")
  textboxRightFactionResource = CreateTextBox(0, -90, 100, 100, upgradeMenuStyle, "RFRes: ")
  textboxTimeFactionResource = CreateTextBox(0, -100, 100, 100, upgradeMenuStyle, "Time: ")
  
  --Value textboxes
  textboxLeftFactionResourceValue = CreateTextBox(90, -80, 100, 100, upgradeMenuStyle, "")
  textboxRightFactionResourceValue = CreateTextBox(90, -90, 100, 100, upgradeMenuStyle, "")
  textboxTimeValue = CreateTextBox(90, -100, 100, 100, upgradeMenuStyle, "")
  textboxNameValue = CreateTextBox(0, 70, 160, 40, upgradeMenuStyle, "")
  textboxNameValue:setAlignment(MOAITextBox.CENTER_JUSTIFY, MOAITextBox.CENTER_JUSTIFY)
  
	textLayer:insertProp(textboxLeftFactionResource)
  textLayer:insertProp(textboxRightFactionResource)
  textLayer:insertProp(textboxTimeFactionResource)
  textLayer:insertProp(textboxLeftFactionResourceValue)
  textLayer:insertProp(textboxRightFactionResourceValue)
  textLayer:insertProp(textboxTimeValue)
  textLayer:insertProp(textboxNameValue)
  textLayer:setPriority(1001)
  
  local upgrade = shipUpgradesList[1]
  SetBuildButtonVisibility(upgrade)
  textboxNameValue:setString(""..upgrade:GetName())
  textboxLeftFactionResourceValue:setString(""..upgrade:GetRequiredResourcesLeftFaction())
  textboxRightFactionResourceValue:setString(""..upgrade:GetRequiredResourcesRightFaction())
  textboxTimeValue:setString(""..upgrade:GetRequiredTime())
  
  propBackButton.name = "leaveUpgradeScreen"
  propBuildButton.name = "buildUpgrade"
  gamestate = "upgrading"
end

function clearLayers()
  menuLayer:clear()
  baselayer:clear()
  basebarlayer:clear()
  backgroundLayer1:clear()
  backgroundLayer2:clear()
  universeLayer:clear()
  eblayer:clear()
  buttonlayer:clear()
  blayer:clear()
  elayer:clear()
  elayer2:clear()
  eblayer:clear()
  ebrlayer:clear()
  layer:clear()
  clayer:clear()
  buttonlayer:clear()
  textLayer:clear()
  upgradeLayer:clear()
  barlayer:clear()
end
