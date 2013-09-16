BACK_WIDTH_1  = 320
BACK_HEIGHT_1 = 180
BACK_WIDTH_2  = 2000
BACK_HEIGHT_2 = 180
STEP_SIZE_1   = 0.5
STEP_SIZE_2   = 2
SCREEN_WIDTH  = 320
SCREEN_HEIGHT = 180

back1texture = MOAIImage.new()
back1texture:load("resources/stars_bg.png")

back1 = MOAIGfxQuad2D.new()
back1:setTexture(back1texture)
back1:setRect(0, ((BACK_HEIGHT_1/2)*-1), BACK_WIDTH_1, BACK_HEIGHT_1/2)

back2texture = MOAIImage.new()
back2texture:load("resources/spaceclouds_bg.png")

back2 = MOAIGfxQuad2D.new()
back2:setTexture(back2texture)
back2:setRect(0, ((BACK_HEIGHT_2/2)*-1), BACK_WIDTH_2, BACK_HEIGHT_2/2)

function createBackProps(layer1, layer2)
  backprop = MOAIProp2D.new()
  backprop:setDeck(back1)
  backprop:setLoc(((SCREEN_WIDTH/2)*-1), 0)
  backprop:setBlendMode( MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA )
  layer1:insertProp(backprop)

  backprop2 = MOAIProp2D.new()
  backprop2:setDeck(back1)
  backprop2:setLoc(((SCREEN_WIDTH/2)*-1)+BACK_WIDTH_1, 0)
  backprop2:setBlendMode( MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA )
  layer1:insertProp(backprop2)
  
  back2prop = MOAIProp2D.new()
  back2prop:setDeck(back2)
  back2prop:setLoc(((SCREEN_WIDTH/2)*-1), 0)
  back2prop:setBlendMode( MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA )
  layer2:insertProp(back2prop)

  back2prop2 = MOAIProp2D.new()
  back2prop2:setDeck(back2)
  back2prop2:setLoc(((SCREEN_WIDTH/2)*-1)+BACK_WIDTH_2, 0)
  back2prop2:setBlendMode( MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA )
  layer2:insertProp(back2prop2)  
end

function moveBackground()
  while true do
    local x1, y1 = backprop:getLoc()
    local x2, y2 = backprop2:getLoc()
    backprop:setLoc(x1-STEP_SIZE_1, y1)
    backprop2:setLoc(x2-STEP_SIZE_1, y2)
    if(x2 <= ((SCREEN_WIDTH/2)*-1)-STEP_SIZE_1) then
      backprop:setLoc(((SCREEN_WIDTH/2)*-1), 0)
      backprop2:setLoc(((SCREEN_WIDTH/2)*-1)+BACK_WIDTH_1, 0)
    end
    
    local x21, y21 = back2prop:getLoc()
    local x22, y22 = back2prop2:getLoc()
    back2prop:setLoc(x21-STEP_SIZE_2, y21)
    back2prop2:setLoc(x22-STEP_SIZE_2, y22)
    if(x22 <= ((SCREEN_WIDTH/2)*-1)-STEP_SIZE_2) then
      back2prop:setLoc(((SCREEN_WIDTH/2)*-1), 0)
      back2prop2:setLoc(((SCREEN_WIDTH/2)*-1)+BACK_WIDTH_2, 0)
    end
    coroutine.yield()
  end
end

function backgroundThread(layer1, layer2)
  createBackProps(layer1, layer2)
  thread = MOAICoroutine.new()
  thread:run(moveBackground)
end
