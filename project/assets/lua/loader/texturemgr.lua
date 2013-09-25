function initTextures()
  --name          path                         x1    y1   x2   y2
  sprite     = cs("resources/ship.png",        -16,  -16, 16,  16) --Player
  bsprite    = cs("resources/bullet_1.png",    -2,   -2,  2,   2)  --Bullet
  e1sprite   = cs("resources/left_small.png",  -12,  -12, 12,  12) --Enemy Left
  e2sprite   = cs("resources/right_small.png", -12,  -12, 12,  12) --Enemy Right
  csprite    = cs("resources/target.png",      -8,   -8,  8,   8)  --Crosshair
  gunsprite  = cs("resources/weapons.png",     -16,  -16, 16,  16) --Gun
  lbsprite   = cs("resources/blue_bar.png",    0,    0,   150, -8) --Left Bar
  rbsprite   = cs("resources/red_bar.png",     -150, -8,  0,   0)  --Right Bar
  basesprite = cs("resources/base.png",        -160, -90, 160, 90) --Base Background
  lfsprite   = cs("resources/blue_fist.png",   -22,  -11, 0,   11) --Left Fist
  rfsprite   = cs("resources/red_fist.png",    0,    -11, 22,  11) --Right Fist
end

function cs(path, x1, y1, x2, y2) -- Create sprite
  local texture = MOAIImage.new()
  texture:load(path)
  local sprite = MOAIGfxQuad2D.new()
  sprite:setTexture(texture)
  sprite:setRect(x1, y1, x2, y2)
  return sprite
end
