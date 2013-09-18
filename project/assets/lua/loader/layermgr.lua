function initLayers()
  backgroundLayer1 = MOAILayer2D.new()
  backgroundLayer1:setViewport(viewport)

  backgroundLayer2 = MOAILayer2D.new()
  backgroundLayer2:setViewport(viewport)

  backlayer = MOAILayer2D.new()
  backlayer:setViewport(viewport)

  layer = MOAILayer2D.new()
  layer:setViewport(viewport)

  blayer = MOAILayer2D.new()
  blayer:setViewport(viewport)

  elayer = MOAILayer2D.new()
  elayer:setViewport(viewport)

  epartition = MOAIPartition.new()
  elayer:setPartition(epartition)

  clayer = MOAILayer2D.new()
  clayer:setViewport(viewport)

  buttonlayer = MOAILayer2D.new()
  buttonlayer:setViewport(viewport)

  textLayer = MOAILayer2D.new()
  textLayer:setViewport(viewport)

  menuLayer = MOAILayer2D.new()
  menuLayer:setViewport(viewport)
  
  loadMenuLayers()
end

function loadFightLayers()
  clearLayers()
  MOAIRenderMgr.pushRenderPass(backgroundLayer1)
  MOAIRenderMgr.pushRenderPass(backgroundLayer2)
  MOAIRenderMgr.pushRenderPass(buttonlayer)
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
	
	menuLayer:insertProp(propStartButton)

	partition = MOAIPartition.new()
	partition:insertProp(propStartButton)
	menuLayer:setPartition(partition)
	  
	gamestate = "pause"
	
	propStartButton.name = "playing"

end

function clearLayers()
  menuLayer:clear()
  backgroundLayer1:clear()
  backgroundLayer2:clear()
  buttonlayer:clear()
  blayer:clear()
  elayer:clear()
  layer:clear()
  clayer:clear()
  buttonlayer:clear()
  textLayer:clear()
end
