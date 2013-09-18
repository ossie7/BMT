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
  MOAIRenderMgr.pushRenderPass(menuLayer)
end
