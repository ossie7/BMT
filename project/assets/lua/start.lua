-- Gamemodes
DUEL   = 1
CHASE  = 2
FLEE   = 3
BATTLE = 4

screenWidth  = nil
screenHeight = nil
screenWidthScale = 320
screenHeightScale = 180
if MOAIEnvironment.OS_BRAND_ANDROID then
  screenWidth, screenHeight = MOAIGfxDevice.getViewSize ()
end
print("Starting up on:" .. MOAIEnvironment.osBrand  .. " version:" .. MOAIEnvironment.osVersion)

if screenWidth  == nil or screenWidth  == 0 then screenWidth  = 320 end
if screenHeight == nil or screenHeight == 0 then screenHeight = 180 end

MOAISim.openWindow("BAD MOTHER TRUCKER",screenWidth,screenHeight)

viewport = MOAIViewport.new()
viewport:setSize(screenWidth, screenHeight)
viewport:setScale(screenWidthScale, screenHeightScale)

leftborder = (screenWidthScale / 2) * -1
rightborder = screenWidthScale / 2
topborder = screenHeightScale / 2
bottomborder = (screenHeightScale / 2) * -1

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

menuLayer = MOAILayer2D.new()
menuLayer:setViewport(viewport)
MOAIRenderMgr.pushRenderPass(menuLayer)

-- Set background colour
--MOAIGfxDevice.getFrameBuffer():setClearColor(0,0,0,0)

function loadFightLayers()
  
  MOAIRenderMgr.pushRenderPass(backgroundLayer1)
  MOAIRenderMgr.pushRenderPass(backgroundLayer2)
  MOAIRenderMgr.pushRenderPass(buttonlayer)
	MOAIRenderMgr.pushRenderPass(blayer)
	MOAIRenderMgr.pushRenderPass(elayer)
	MOAIRenderMgr.pushRenderPass(layer)
  MOAIRenderMgr.pushRenderPass(clayer)
  
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
    
  pausePartition = MOAIPartition.new()
	pausePartition:insertProp(propButton)
	buttonlayer:setPartition(pausePartition)
  gamestate = "playing"
  propButton.name = "pause"
end

function loadMenuLayers()
  
  backgroundLayer1:clear()
  backgroundLayer2:clear()
  buttonlayer:clear()
  blayer:clear()
  elayer:clear()
  layer:clear()
  clayer:clear()
  buttonlayer:clear()
  
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
	
	textboxGameMode = MOAITextBox.new()
	textboxGameMode:setStyle(style)
	textboxGameMode:setString("<c:f70>Game mode = <c>"..gamestate)
	textboxGameMode:setRect(-320, -80, 50, 49)
	textboxGameMode:setAlignment( MOAITextBox.RIGHT_JUSTIFY , MOAITextBox.RIGHT_JUSTIFY )
	textboxGameMode:setYFlip ( true )
	menuLayer:insertProp(textboxGameMode)
	
	propStartButton.name = "playing"

end
