universeImage = MOAIImage.new()
universeImage:load("resources/backgrounds/space_flat.png")

universeSprite = MOAIGfxQuad2D.new()
universeSprite:setTexture(universeImage)
universeSprite:setRect(-512, -512, 512, 512 )


function createUniverseBackProps(layer)
  universeProp = MOAIProp2D.new()
  universeProp:setDeck(universeSprite)
  universeProp:setLoc(200, -300)
  universeProp:setBlendMode( MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA )
  universeLayer:insertProp(universeProp)
end

STEP_SIZE_1 = 1

function moveUniverseBackground()
  while true do
    if(popupActive == false) then
      local x1, y1 = universeProp:getLoc()
      universeProp:moveRot(0.05)
    end
    coroutine.yield()
  end
end

function universeThread(layer)
  createUniverseBackProps(layer)
  thread = MOAICoroutine.new()
  thread:run(moveUniverseBackground)
end
