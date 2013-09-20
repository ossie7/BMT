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

  elayer = MOAILayer2D.new()
  elayer:setViewport(viewport)

  epartition = MOAIPartition.new()
  elayer:setPartition(epartition)
  
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
  
  loadMenuLayers()
end

function loadFightLayers()
  clearLayers()
  MOAIRenderMgr.pushRenderPass(backgroundLayer1)
  MOAIRenderMgr.pushRenderPass(backgroundLayer2)
  MOAIRenderMgr.pushRenderPass(universeLayer)
  MOAIRenderMgr.pushRenderPass(buttonlayer)
  MOAIRenderMgr.pushRenderPass(eblayer)
  MOAIRenderMgr.pushRenderPass(ebrlayer)
	MOAIRenderMgr.pushRenderPass(blayer)
	MOAIRenderMgr.pushRenderPass(elayer)
	MOAIRenderMgr.pushRenderPass(layer)
  MOAIRenderMgr.pushRenderPass(clayer)
  MOAIRenderMgr.pushRenderPass(textLayer)
  
  texturePause = MOAIImage.new()
  texturePause:load("resources/wm_pause.png")
  
  spritePauseButton = MOAIGfxQuad2D.new()
	spritePauseButton:setTexture(texturePause)
	spritePauseButton:setRect(-16, -16, 16, 16);
  
  propButton = MOAIProp2D.new()
	propButton:setDeck(spritePauseButton)
	propButton:setLoc(-70,-65)
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
	textboxHealth:setRect(-50,-50,50,50)
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
  
  MOAIRenderMgr.pushRenderPass(menuLayer)
	
	texturePlay = MOAIImage.new()
  texturePlay:load("resources/play_button.png")
  
	spriteStartButton = MOAIGfxQuad2D.new()
	spriteStartButton:setTexture(texturePlay)
	spriteStartButton:setRect(-32, -32, 32, 32);
	  
	propStartButton = MOAIProp2D.new()
	propStartButton:setDeck(spriteStartButton)
	propStartButton:setLoc(-120,80)
  propStartButton:setBlendMode( MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA )
  
  propShipUpgradesButton = MOAIProp2D.new()
	propShipUpgradesButton:setDeck(spriteStartButton)
	propShipUpgradesButton:setLoc(120,80)
  propShipUpgradesButton:setBlendMode( MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA )

	partition = MOAIPartition.new()
	partition:insertProp(propStartButton)
  partition:insertProp(propShipUpgradesButton)
	menuLayer:setPartition(partition)
	  
	gamestate = "pause"
	
	propStartButton.name = "playing"
  propShipUpgradesButton.name = "shipUpgrades"

end

function loadShipUpgradesLayers()
  clearLayers()
   
  MOAIRenderMgr.pushRenderPass(upgradeLayer)
  
  texturePlay = MOAIImage.new()
  texturePlay:load("resources/play_button.png")
  
	spriteBackButton = MOAIGfxQuad2D.new()
	spriteBackButton:setTexture(texturePlay)
	spriteBackButton:setRect(-32, -32, 32, 32);
  
  propBackButton = MOAIProp2D.new()
	propBackButton:setDeck(spriteBackButton)
	propBackButton:setLoc(-130,-60)
  propBackButton:setBlendMode( MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA )
  
  upgradePartition = MOAIPartition.new()
	upgradePartition:insertProp(propBackButton)
	upgradeLayer:setPartition(upgradePartition)
  
  SetupShipUpgradesList()
  
  propBackButton.name = "leaveUpgradeScreen"
  gamestate = "upgrading"
end

function clearLayers()
  menuLayer:clear()
  backgroundLayer1:clear()
  backgroundLayer2:clear()
  universeLayer:clear()
  eblayer:clear()
  buttonlayer:clear()
  blayer:clear()
  elayer:clear()
  eblayer:clear()
  ebrlayer:clear()
  layer:clear()
  clayer:clear()
  buttonlayer:clear()
  textLayer:clear()
  upgradeLayer:clear()
end
