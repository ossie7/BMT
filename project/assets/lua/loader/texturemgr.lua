function initTextures()
  --name          path                         x1    y1   x2   y2
  sprite       = cs("resources/ship.png",        -16,  -16, 16,  16) --Player
  bsprite      = cs("resources/bullet_1.png",    -2,   -2,  2,   2)  --Bullet
  eb1sprite    = cs("resources/bullet_2.png",    -2,   -2,  2,   2)  --Enemy Bullet Left
  eb2sprite    = cs("resources/bullet_3.png",    -2,   -2,  2,   2)  --Enemy Bullet Right
  e1sprite     = cs("resources/left_small.png",  -12,  -12, 12,  12) --Enemy Left
  e2sprite     = cs("resources/right_small.png", -12,  -12, 12,  12) --Enemy Right
  csprite      = cs("resources/target.png",      -8,   -8,  8,   8)  --Crosshair
  gunsprite    = cs("resources/weapons.png",     -16,  -16, 16,  16) --Gun
  lbsprite     = cs("resources/blue_bar.png",    0,    0,   150, -8) --Left Bar
  rbsprite     = cs("resources/red_bar.png",     -150, -8,  0,   0)  --Right Bar
  basesprite   = cs("resources/base.png",        -160, -90, 160, 90) --Base Background
  lfsprite     = cs("resources/blue_fist.png",   -22,  -11, 0,   11) --Left Fist
  rfsprite     = cs("resources/red_fist.png",    0,    -11, 22,  11) --Right Fist
  metalSprite  = cs("resources/metal.png",       -4,   -4,  4,   4)  --Metal Icon
  plasmaSprite = cs("resources/energy.png",      -4,   -4,  4,   4)  --Energy Icon
  gtsprite     = cs("resources/gun_toggle.png" , -16,  -8,  16,  8)  --Gun Toggle Button
  shipUpgradeScreenSprite =     cs("resources/ship_upgrade.png",    -160, -90,  160,  90) -- shipupgrades background
  stationUpgradeScreenSprite =  cs("resources/station_upgrade.png", -160, -90,  160,  90) -- stationupgrades background
  warroomShipUpgradeSprite    = cs("resources/transparent.png", -15,  -23, 15,  23) --Ship upgrades button warroom
  warroomStationUpgradeSprite = cs("resources/transparent.png", -15,  -25, 15,  25) --Station upgrades button warroom
  warroomStartBattleSprite    = cs("resources/transparent.png", -15,  -25, 15,  25) --Start Battle button warroom
  warroomButtonSprite         = cs("resources/transparent.png", -16,  -18, 16,  18) --warroom buttons
	spritePauseButton           = cs("resources/wm_pause.png",    -8,   -8,  8,   8)  --Pause button
  
  tileLib = MOAITileDeck2D.new()
  tileLib:setTexture("resources/explo_sprite.png")
  -- aantal afbeeldingen h*b
  tileLib:setSize(4 , 2)
  tileLib:setRect(-16,-16,16,16)

end

function cs(path, x1, y1, x2, y2) -- Create sprite
  local texture = MOAIImage.new()
  texture:load(path)
  local sprite = MOAIGfxQuad2D.new()
  sprite:setTexture(texture)
  sprite:setRect(x1, y1, x2, y2)
  return sprite
end
