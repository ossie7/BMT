function initTextures()

  -- Backgrounds
  basesprite = cs("resources/backgrounds/base_empty_proper.png", -160, -90, 160, 90) --Base Background
  shipUpgradeScreenSprite    = cs("resources/backgrounds/ship_upgrade.png",    -160, -90,  160, 90) -- Shipupgrades background
  stationUpgradeScreenSprite = cs("resources/backgrounds/station_upgrade.png", -160, -90,  160, 90) -- Stationupgrades background
  
  -- Enemies
  blueSniper    = cs("resources/enemies/blue/sniper.png",     -16,   -16,  16,   16)  --Blue Sniper
  blueSniperGun = cs("resources/enemies/blue/sniper_gun.png", -10.5, -2.5, 10.5, 2.5) --Blue Sniper Gun
  blueTankGun   = cs("resources/enemies/blue/tank_gun.png",   -8.5,  -6,   8.5,  6)   --Blue Tank Gun
  eb1sprite     = cs("resources/enemies/blue/bullet.png",     -2,    -2,   2,    2)   --Enemy Bullet Left
  redSniper     = cs("resources/enemies/red/sniper.png",      -16,   -16,  16,   16)  --Red Sniper
  redSniperGun  = cs("resources/enemies/red/sniper_gun.png",  -16,   -16,  16,   16)  --Red Sniper Gun
  redTank       = cs("resources/enemies/red/tank.png",        -32,   -32,  32,   32)  --Red Tank
  redTankGun1   = cs("resources/enemies/red/tank_gun.png",    -32,   -32,  32,   32)  --Red Tank Gun 1
  redTankGun2   = cs("resources/enemies/red/tank_gun_b.png",  -32,   -32,  32,   32)  --Red Tank Gun 2
  eb2sprite     = cs("resources/enemies/red/bullet.png",      -2,    -2,   2,    2)   --Enemy Bullet Right
  invisGun      = cs("resources/enemies/invis_gun.png",       -1,    -1,   1,    1)   --Invisible Gun
  
  
  -- GUI
  lbsprite             = cs("resources/gui/blue_bar.png",     0,     0,   150,  -4)  --Left Base Bar
  rbsprite             = cs("resources/gui/red_bar.png",      -150,  -4,  0,    0)   --Right Base Bar
  lfsprite             = cs("resources/gui/blue_fist.png",    -22,   -11, 0,    11)  --Left Base Fist
  rfsprite             = cs("resources/gui/red_fist.png",     0,     -11, 22,   11)  --Right Base Fist
  metalSprite          = cs("resources/gui/metal.png",        -4,    -4,  4,    4)   --Metal Icon
  plasmaSprite         = cs("resources/gui/energy.png",       -4,    -4,  4,    4)   --Energy Icon
  wzSprite             = cs("resources/gui/warzones.png",     -160,  -90, 160,  90)  --Warzones
  popupSprite          = cs("resources/gui/popup.png",        -152,  -72, 152,  73)  --Popup Background
  popupButtonSprite    = cs("resources/gui/popup_button.png", -24,   -10, 25,   11)  --Popup Button
  popupButtonLrgSprite = cs("resources/gui/popup_btn_lrg.png",-39,   -10, 40,   11)  --Popup Button large
  spritePauseButton    = cs("resources/gui/back_button.png",  -14,   -10, 14,   10)  --Pause button
  chatboxShipSprite    = cs("resources/gui/ship_chat.png",    -66,   -24, 66,   24)  --Ship Upgrade Chat
  chatboxStationSprite = cs("resources/gui/station_chat.png", -66,   -24, 66,   24)  --Station Upgrade Chat
  backButtonSprite     = cs("resources/gui/back_button.png",  -10.5, -10, 10.5, 10)  --Back Button
  buildButtonSprite    = cs("resources/gui/build_button.png", -10,   -10, 10,   10)  --Build Button
  guiBaseSprite        = cs("resources/gui/GUI_base.png",     -15,   0,   16,   16)  --Control Base
  guiLifeSprite        = cs("resources/gui/GUI_life.png",     -20,   0,   20,   16)  --Life Base
  guiAutoSprite        = cs("resources/gui/auto_fire.png",    -11,   0,   11,   23)  --Auto-fire Button
  guiRegenSprite       = cs("resources/gui/regen.png",        -11,   0,   11,   23)  --Regen Button
  guiStickSprite       = cs("resources/gui/stick.png",        -34,   0,   35,   37)  --Control Stick
  guiStickSmallSprite  = cs("resources/gui/stick.png",        -24.5, 0,   24.5, 34)  --Control Stick
  powerMainSprite      = cs("resources/gui/power_main.png",   -160,  -90, 160,  90)  --Power Main
  powerSplitSprite     = cs("resources/gui/power_meter.png",  -15,   -6,  15,   6)   --Power Indicator
  pbsprite             = cs("resources/gui/power_bar.png",    0,     0,   0,    -12) --Power Bar
  glbsprite            = cs("resources/gui/power_blue.png",   -137,  -4,  0,    0)   --Left Bar
  grbsprite            = cs("resources/gui/power_red.png",    0,     0,   137,  -4)  --Right Bar
  battleOverlay        = cs("resources/gui/over/battle.png",  -160,  -90, 160,  90)  --Battle Start Overlay
  
  -- NPC
  engineer  = cs("resources/npc/engineer.png",  -9.5, -15, 9.5, 15) --Engineer
  architect = cs("resources/npc/architect.png", -5.5, -14, 5.5, 14) --Architect
  captain   = cs("resources/npc/captain.png",   -8.5, -16, 8.5, 16) --Captain
  engineerSprite  = cs("resources/npc/engineer_portrait.png",  -36, -49, 36, 49) --Engineer portrait
  architectSprite = cs("resources/npc/architect_portrait.png", -36, -49, 36, 49) --Architect portrait
  captainSprite   = cs("resources/npc/captain_portrait.png",   -36, -49, 36, 49) --Captain portrait
  
  -- Others
  splashLogo        = cs("resources/others/icon.png",      -48, -48, 48, 48) --Game Logo
  waterModuleSprite = cs("resources/others/waterchip.png", -25, -19, 25, 19) --Water Module
  
  -- Ship
  playerSingle = cs("resources/ship/ship_single.png",   -32, -32, 32, 32) --Ship
  playerarm    = cs("resources/ship/arm.png",    0,   0,   12, 4)  --Ship Arm
  bsprite      = cs("resources/ship/bullet.png", -2,  -2,  2,  2)  --Bullet
  csprite      = cs("resources/ship/target.png", -8,  -8,  8,  8)  --Crosshair
  
  
  -- Animations
  playerSprite = MOAIImage.new()
  playerSprite:load("resources/ship/ship.png")
  player = MOAITileDeck2D.new()
  player:setTexture(playerSprite)
  player:setSize(4 , 3)
  player:setRect(-32, -32, 32, 32)
  
  eximage = MOAIImage.new()
  eximage:load("resources/others/explosion.png")
  tileLib = MOAITileDeck2D.new()
  tileLib:setTexture(eximage)
  tileLib:setSize(4 , 2)
  tileLib:setRect(-16, -16, 16, 16)
  
  bdtimage = MOAIImage.new()
  bdtimage:load("resources/enemies/blue/drone.png")
  blueDroneTileLib = MOAITileDeck2D.new()
  blueDroneTileLib:setTexture(bdtimage)
  blueDroneTileLib:setSize(5, 3)
  blueDroneTileLib:setRect(-16, -16, 16, 16)
  
  bttimage = MOAIImage.new()
  bttimage:load("resources/enemies/blue/tank.png")
  blueTankTileLib = MOAITileDeck2D.new()
  blueTankTileLib:setTexture(bttimage)
  blueTankTileLib:setSize(3, 1)
  blueTankTileLib:setRect(-32, -32, 32, 32)
  
  rdtimage = MOAIImage.new()
  rdtimage:load("resources/enemies/red/drone.png")
  redDroneTileLib = MOAITileDeck2D.new()
  redDroneTileLib:setTexture(rdtimage)
  redDroneTileLib:setSize(4, 2)
  redDroneTileLib:setRect(-16, -16, 16, 16)
  
  guiDigits = MOAIImage.new()
  guiDigits:load("resources/fonts/digits.png")
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
