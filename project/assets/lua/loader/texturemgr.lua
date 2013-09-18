function initTextures()
  truck = MOAIImage.new()
  truck:load("resources/truck.png")
  sprite = MOAIGfxQuad2D.new() -- Player
  sprite:setTexture(truck)
  sprite:setRect(-32,-32,32,32)

  texture = MOAIImage.new()
  texture:load("resources/thing.png")
  bsprite = MOAIGfxQuad2D.new() -- Bullet
  bsprite:setTexture(texture)
  bsprite:setRect(-8,-8,8,8)

  esprite = MOAIGfxQuad2D.new() -- Enemy
  esprite:setTexture(texture)
  esprite:setRect(-12,-12,12,12)

  crosstexture = MOAIImage.new()
  crosstexture:load("resources/cross.png")
  csprite = MOAIGfxQuad2D.new() -- Crosshair
  csprite:setTexture(crosstexture)
  csprite:setRect(-8,-8,8,8)

  guntexture = MOAIImage.new()
  guntexture:load("resources/gun.png")
  gunsprite = MOAIGfxQuad2D.new() -- Gun
  gunsprite:setTexture(guntexture)
  gunsprite:setRect(-8,-8,8,8)
end
