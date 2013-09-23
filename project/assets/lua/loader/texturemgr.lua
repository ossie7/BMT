function initTextures()
  truck = MOAIImage.new()
  truck:load("resources/Ship.png")
  sprite = MOAIGfxQuad2D.new() -- Player
  sprite:setTexture(truck)
  sprite:setRect(-16,-16,16,16)

  texture = MOAIImage.new()
  texture:load("resources/bullet_1.png")
  bsprite = MOAIGfxQuad2D.new() -- Bullet
  bsprite:setTexture(texture)
  bsprite:setRect(-2,-2,2,2)
  
  pirateTexture = MOAIImage.new()
  pirateTexture:load("resources/pirate_small.png")
  pirateSprite = MOAIGfxQuad2D.new() -- Pirate
  pirateSprite:setTexture(pirateTexture)
  pirateSprite:setRect(-12,-12,12,12)


  esprite = MOAIGfxQuad2D.new() -- Enemy
  esprite:setTexture(pirateTexture)
  esprite:setRect(-12,-12,12,12)

  crosstexture = MOAIImage.new()
  crosstexture:load("resources/target.png")
  csprite = MOAIGfxQuad2D.new() -- Crosshair
  csprite:setTexture(crosstexture)
  csprite:setRect(-8,-8,8,8)

  guntexture = MOAIImage.new()
  guntexture:load("resources/Ship_weapons.png")
  gunsprite = MOAIGfxQuad2D.new() -- Gun
  gunsprite:setTexture(guntexture)
  gunsprite:setRect(-16,-16,16,16)
end
