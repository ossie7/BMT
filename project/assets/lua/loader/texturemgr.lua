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
  
  e1texture = MOAIImage.new()
  e1texture:load("resources/left_small.png")
  e1sprite = MOAIGfxQuad2D.new() -- Enemy left
  e1sprite:setTexture(e1texture)
  e1sprite:setRect(-12,-12,12,12)
  
  e2texture = MOAIImage.new()
  e2texture:load("resources/right_small.png")
  e2sprite = MOAIGfxQuad2D.new() -- Enemy right
  e2sprite:setTexture(e2texture)
  e2sprite:setRect(-12,-12,12,12)

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
  
  lbtexture = MOAIImage.new()
  lbtexture:load("resources/blue_bar.png")
  lbsprite = MOAIGfxQuad2D.new() -- Left bar
  lbsprite:setTexture(lbtexture)
  lbsprite:setRect(0,0,150,-8)
  
  rbtexture = MOAIImage.new()
  rbtexture:load("resources/red_bar.png")
  rbsprite = MOAIGfxQuad2D.new() -- Right bar
  rbsprite:setTexture(rbtexture)
  rbsprite:setRect(-150,-8,0,0)
  
  basetexture = MOAIImage.new()
  basetexture:load("resources/base.png")
  basesprite = MOAIGfxQuad2D.new() -- Base background
  basesprite:setTexture(basetexture)
  basesprite:setRect(-160,-90,160,90)
  
  lftexture = MOAIImage.new()
  lftexture:load("resources/blue_fist.png")
  lfsprite = MOAIGfxQuad2D.new() -- Left fist
  lfsprite:setTexture(lftexture)
  lfsprite:setRect(-22,-11,0,11)
  
  rftexture = MOAIImage.new()
  rftexture:load("resources/red_fist.png")
  rfsprite = MOAIGfxQuad2D.new() -- Right fist
  rfsprite:setTexture(rftexture)
  rfsprite:setRect(0,-11,22,11)
end
