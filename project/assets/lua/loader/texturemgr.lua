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
  basesprite   = cs("resources/base_empty_proper.png",        -160, -90, 160, 90) --Base Background
  engineer     = cs("resources/engineer.png",    -9.5,  -15,  9.5,  15) --engineer
  architect    = cs("resources/architect.png",    -5.5,  -14,  5.5,  14) --engineer
  captain      = cs("resources/captain.png",    -8.5,  -16,  8.5,  16) --engineer
  lfsprite     = cs("resources/blue_fist.png",   -22,  -11, 0,   11) --Left Fist
  rfsprite     = cs("resources/red_fist.png",    0,    -11, 22,  11) --Right Fist
  metalSprite  = cs("resources/metal.png",       -4,   -4,  4,   4)  --Metal Icon
  plasmaSprite = cs("resources/energy.png",      -4,   -4,  4,   4)  --Energy Icon
  spriteGoMenu = cs("resources/play_button.png", -8,   -8,  8,   8)  --Play Button
  popupSprite  = cs("resources/popup.png",       -152, -72, 152, 73) --Popup Background
  popupButtonSprite           = cs("resources/popup_button.png",    -24,  -10,  25,  11)   --Popup Button
  shipUpgradeScreenSprite     = cs("resources/ship_upgrade.png",    -160, -90,  160, 90) -- shipupgrades background
  stationUpgradeScreenSprite  = cs("resources/station_upgrade.png", -160, -90,  160, 90) -- stationupgrades background
  warroomShipUpgradeSprite    = cs("resources/transparent.png",     -15,  -23,  15,  23)   --Ship upgrades button warroom
  warroomStationUpgradeSprite = cs("resources/transparent.png",     -15,  -25,  15,  25)   --Station upgrades button warroom
  warroomStartBattleSprite    = cs("resources/transparent.png",     -15,  -25,  15,  25)   --Start Battle button warroom
  warroomButtonSprite         = cs("resources/transparent.png",     -16,  -18,  16,  18)   --warroom buttons
	spritePauseButton           = cs("resources/wm_pause.png",         -8,   -8,  8,    8)   --Pause button
  waterModuleSprite           = cs("resources/waterchip_module.png",-25,  -19,  25,  19)
  chatboxShipSprite           = cs("resources/ship_chatbox.png",    -66,  -24,  66,  24)
  chatboxStationSprite        = cs("resources/station_chatbox.png", -66,  -24,  66,  24)
  --GUI
  guiBaseSprite  = cs("resources/GUI_base.png",       -15, 0,   16, 16) --Control Base
  guiLifeSprite  = cs("resources/GUI_life.png",       -20, 0,   20, 16) --Life Base
  guiAutoSprite  = cs("resources/icon_auto_fire.png", -11, 0,   11, 23) --Auto-fire Button
  guiRegenSprite = cs("resources/icon_regen.png",     -11, 0,   11, 23) --Regen Button
  guiStickSprite = cs("resources/stick.png",          -34, 0,   35, 37) --Control Stick
  
  
  tileLib = MOAITileDeck2D.new()
  tileLib:setTexture("resources/explo_sprite.png")
  -- aantal afbeeldingen h*b
  tileLib:setSize(4 , 2)
  tileLib:setRect(-16,-16,16,16)
  
  guiDigits = MOAIImage.new()
  guiDigits:load("resources/digits_sprite.png")
  digits = MOAITileDeck2D.new()
  digits:setTexture(guiDigits)
  digits:setSize(5, 2)
  digits:setRect(-16, -16, 16, 16)

end

function cs(path, x1, y1, x2, y2) -- Create sprite
  local texture = MOAIImage.new()
  texture:load(path)
  local sprite = MOAIGfxQuad2D.new()
  sprite:setTexture(texture)
  sprite:setRect(x1, y1, x2, y2)
  return sprite
end
