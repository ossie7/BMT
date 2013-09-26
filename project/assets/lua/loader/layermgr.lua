function cl()
  local layer = MOAILayer2D.new()
  layer:setViewport(viewport)
  return layer
end

function cp(layer)
  local partition = MOAIPartition.new()
  layer:setPartition(partition)
  return partition
end

function initLayers()
  universeLayer = cl() --Universe background
  layer         = cl() --Ship
  clayer        = cl() --Crosshair/gun
  buttonlayer   = cl() --Menu buttons
  textLayer     = cl() --Text
  menuLayer     = cl() --Menu
  upgradeLayer  = cl() --Upgrade
  barlayer      = cl() --Fight progress bars
  baselayer     = cl() --Base background
  basebarlayer  = cl() --Warzone bars
  blayer        = cl() --Bullets
  bpartition    = cp(blayer)
  elayer        = cl() --Enemy bullets
  epartition    = cp(elayer)
  elayer2       = cl() --Right enemies
  epartition2   = cp(elayer2)
  eblayer       = cl() --Enemy bullets
  ebpartition   = cp(eblayer)
  ebrlayer      = cl() --Reflected enemy bullets
  ebrpartition  = cp(ebrlayer)
  endweeklayer  = cl()
  upgradeback   = cl()
  
  loadMenuLayers()
end

function loadFightLayers()
  currentWave = 1
  week = week + 1
  battleDone = 0
  
  propExplosion = MOAIProp2D.new()
  propExplosion:setDeck(tileLib)

  curve = MOAIAnimCurve.new()
  curve:reserveKeys(8)

  for i=1, 8, 1 do
    -- index, time, hoeveelste plaatje
    curve:setKey(i, 0.05 * i, i)
    
  end

  clearLayers()
  MOAIRenderMgr.pushRenderPass(universeLayer)
  MOAIRenderMgr.pushRenderPass(buttonlayer)
  MOAIRenderMgr.pushRenderPass(eblayer)
  MOAIRenderMgr.pushRenderPass(ebrlayer)
	MOAIRenderMgr.pushRenderPass(elayer)
  MOAIRenderMgr.pushRenderPass(elayer2)
	MOAIRenderMgr.pushRenderPass(layer)
  MOAIRenderMgr.pushRenderPass(blayer)
  MOAIRenderMgr.pushRenderPass(clayer)
  MOAIRenderMgr.pushRenderPass(textLayer)
  MOAIRenderMgr.pushRenderPass(barlayer)
  
  texturePause = MOAIImage.new()
  texturePause:load("resources/wm_pause.png")
  
  spritePauseButton = MOAIGfxQuad2D.new()
	spritePauseButton:setTexture(texturePause)
	spritePauseButton:setRect(-8, -8, 8, 8)
  
  propButton = MOAIProp2D.new()
	propButton:setDeck(spritePauseButton)
	propButton:setLoc(-130,-70)
  propButton:setBlendMode( MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA )
  propButton:setPriority(1000)
  
  buttonlayer:insertProp(propButton)
  buttonlayer:setPriority(1000)
  
  textboxGameMode = MOAITextBox.new()
	textboxGameMode:setStyle(style)
	textboxGameMode:setString("Turn "..week)
	textboxGameMode:setRect(-50,-50,50,50)
  textboxGameMode:setLoc(-100,30)
	textboxGameMode:setYFlip ( true )
	textLayer:insertProp(textboxGameMode)
  textLayer:setPriority(1001)
  
  textboxHealth = MOAITextBox.new()
	textboxHealth:setStyle(style)
	textboxHealth:setString("Health ="..health)
	textboxHealth:setRect(-60,-50,60,50)
  textboxHealth:setLoc(100,30)
	textboxHealth:setYFlip ( true )
	textLayer:insertProp(textboxHealth)
    
  pausePartition = MOAIPartition.new()
	pausePartition:insertProp(propButton)
	buttonlayer:setPartition(pausePartition)
  gamestate = "playing"
  propButton.name = "pause"
end

function loadMenuLayers()
  clearLayers()
  
  MOAIRenderMgr.pushRenderPass(baselayer)
  MOAIRenderMgr.pushRenderPass(basebarlayer)
  MOAIRenderMgr.pushRenderPass(menuLayer)
	
  basebackprop = MOAIProp2D.new()
	basebackprop:setDeck(basesprite)
	basebackprop:setLoc(0,0)
  basebackprop:setBlendMode( MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA )
  baselayer:insertProp(basebackprop)
  --[[
  textureMetal = MOAIImage.new()
  textureMetal:load("resources/metal.png")
  
  spriteMetal = MOAIGfxQuad2D.new()
	spriteMetal:setTexture(textureMetal)
	spriteMetal:setRect(-4, -4, 4, 4);
  
  propMetal = MOAIProp2D.new()
	propMetal:setDeck(spriteMetal)
	propMetal:setLoc(90,80)
  propMetal:setBlendMode( MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA )
  
  textboxMetalAmount = CreateTextBox(115, 82, 30, 15, upgradeMenuStyle, ""..amountOfMetal)
  textboxEnergyAmount = CreateTextBox(150, 82, 30, 15, upgradeMenuStyle, ""..amountOfEnergy)
  
  textureEnergy = MOAIImage.new()
  textureEnergy:load("resources/energy.png")
  
  spriteEnergy = MOAIGfxQuad2D.new()
	spriteEnergy:setTexture(textureEnergy)
	spriteEnergy:setRect(-4, -4, 4, 4);
  
  propEnergy = MOAIProp2D.new()
	propEnergy:setDeck(spriteEnergy)
	propEnergy:setLoc(120,80)
  propEnergy:setBlendMode( MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA )
  -------------------------]]
  loadBaseBars()
	  
	propStartButton = MOAIProp2D.new()
	propStartButton:setDeck(warroomStartBattleSprite)
	propStartButton:setLoc(12, -15)
  propStartButton:setBlendMode( MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA )
  
  propShipUpgradesButton = MOAIProp2D.new()
	propShipUpgradesButton:setDeck(warroomShipUpgradeSprite)
	propShipUpgradesButton:setLoc(-65, -50)
  propShipUpgradesButton:setBlendMode( MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA )
  
  propStationUpgradesButton = MOAIProp2D.new()
	propStationUpgradesButton:setDeck(warroomStationUpgradeSprite)
	propStationUpgradesButton:setLoc(65, -38)
  propStationUpgradesButton:setBlendMode( MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA )

	partition = MOAIPartition.new()
	partition:insertProp(propStartButton)
  partition:insertProp(propShipUpgradesButton)
  partition:insertProp(propStationUpgradesButton)
	menuLayer:setPartition(partition)
	  
	gamestate = "pause"
	
	propStartButton.name = "playing"
  propShipUpgradesButton.name = "shipUpgrades"

end

function loadBaseBars()
  local left = ((userdata.warzone - 0.5) / 9) * 212
  local right = ((9.5 - userdata.warzone) / 9) * -212
  local fist = ((userdata.warzone - 5) / 9 ) * 212
  
  lbprop = MOAIProp2D.new()
	lbprop:setDeck(lbsprite)
	lbprop:setLoc(-128,38)
  lbprop:setBlendMode( MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA )
  basebarlayer:insertProp(lbprop)
  lbsprite:setRect(0,0,left,-11)
  
  rbprop = MOAIProp2D.new()
	rbprop:setDeck(rbsprite)
	rbprop:setLoc(128,38)
  rbprop:setBlendMode( MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA )
  basebarlayer:insertProp(rbprop)
  rbsprite:setRect(right,-11,0,0)
  
  lfprop = MOAIProp2D.new()
	lfprop:setDeck(lfsprite)
	lfprop:setLoc(fist,33)
  lfprop:setBlendMode( MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA )
  basebarlayer:insertProp(lfprop)
  
  rfprop = MOAIProp2D.new()
	rfprop:setDeck(rfsprite)
	rfprop:setLoc(fist,33)
  rfprop:setBlendMode( MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA )
  basebarlayer:insertProp(rfprop)
end

function loadShipUpgradesLayers()
  clearLayers()
  
  MOAIRenderMgr.pushRenderPass(upgradeback)
  MOAIRenderMgr.pushRenderPass(upgradeLayer)
  MOAIRenderMgr.pushRenderPass(textLayer)
  
  texturePlay = MOAIImage.new()
  texturePlay:load("resources/play_button.png")
  
  textureMetal = MOAIImage.new()
  textureMetal:load("resources/metal.png")
  
  spriteMetal = MOAIGfxQuad2D.new()
	spriteMetal:setTexture(textureMetal)
	spriteMetal:setRect(-4, -4, 4, 4);
  
  propMetal = MOAIProp2D.new()
	propMetal:setDeck(spriteMetal)
	propMetal:setLoc(90,80)
  propMetal:setBlendMode( MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA )
  local amountOfMetal = 0
  local amountOfEnergy = 0
  if(userdata.metal == nil) then
        
    amountOfMetal = 0
  else
    amountOfMetal = userdata.metal
  end
  
  if(userdata.tech == nil) then
        
    amountOfEnergy = 0
  else
    amountOfEnergy = userdata.tech
  end
  
  textboxMetalAmount = CreateTextBox(115, 82, 30, 15, upgradeMenuStyle, ""..amountOfMetal)
  textboxEnergyAmount = CreateTextBox(150, 82, 30, 15, upgradeMenuStyle, ""..amountOfEnergy)
  
  textureEnergy = MOAIImage.new()
  textureEnergy:load("resources/energy.png")
  
  spriteEnergy = MOAIGfxQuad2D.new()
	spriteEnergy:setTexture(textureEnergy)
	spriteEnergy:setRect(-4, -4, 4, 4);
  
  propEnergy = MOAIProp2D.new()
	propEnergy:setDeck(spriteEnergy)
	propEnergy:setLoc(120,80)
  propEnergy:setBlendMode( MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA )
  
  textureUpgradeBackground = MOAIImage.new()
  textureUpgradeBackground:load("resources/upgrade.png")
  
  spriteUpgradeBackground = MOAIGfxQuad2D.new()
	spriteUpgradeBackground:setTexture(textureUpgradeBackground)
	spriteUpgradeBackground:setRect(-160, -90, 160, 90);
  
  propUpgradeBackground = MOAIProp2D.new()
	propUpgradeBackground:setDeck(spriteUpgradeBackground)
	propUpgradeBackground:setLoc(0,0)
  propUpgradeBackground:setBlendMode( MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA )
  
	spriteBackButton = MOAIGfxQuad2D.new()
	spriteBackButton:setTexture(texturePlay)
	spriteBackButton:setRect(-32, -32, 32, 32);
  
  propBackButton = MOAIProp2D.new()
	propBackButton:setDeck(spriteBackButton)
	propBackButton:setLoc(-130,-60)
  propBackButton:setBlendMode( MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA )
  
  propBuildButton = MOAIProp2D.new()
	propBuildButton:setDeck(spriteBackButton)
	propBuildButton:setLoc(130,-60)
  propBuildButton:setBlendMode( MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA )
  
  propPlayerShip = MOAIProp2D.new()
	propPlayerShip:setDeck(sprite)
	propPlayerShip:setLoc(0, 10)
  propPlayerShip:setScl(3)
  propPlayerShip:setBlendMode( MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA )
  
  upgradePartition = MOAIPartition.new()
  
  upgradeback:insertProp(propUpgradeBackground)
  upgradeback:insertProp(propMetal)
  upgradeback:insertProp(propEnergy)
  upgradeback:insertProp(textboxMetalAmount)
  upgradeback:insertProp(textboxEnergyAmount)
	upgradePartition:insertProp(propBackButton)
  upgradePartition:insertProp(propBuildButton)
	upgradeLayer:setPartition(upgradePartition)
  upgradeLayer:insertProp(propPlayerShip)
  
  LoadShipUpgradesList()
  
  -- name textboxes
  --textboxMetal = CreateTextBox(0, -80, 100, 100, upgradeMenuStyle, "Metal: ")
  --textboxTech = CreateTextBox(0, -90, 100, 100, upgradeMenuStyle, "Tech: ")
  --textboxTime = CreateTextBox(0, -100, 100, 100, upgradeMenuStyle, "Time: ")
  
  --Value textboxes
  textboxMetalValue = CreateTextBox(-48, -66, 64, 15, upgradeMenuStyle, "")
  textboxTechValue = CreateTextBox(92, -66, 64, 15, upgradeMenuStyle, "")
  textboxTimeValue = CreateTextBox(27, -66, 64, 15, upgradeMenuStyle, "")
  textboxNameValue = CreateTextBox(0, 70, 160, 40, upgradeMenuStyle, "")
  textboxNameValue:setAlignment(MOAITextBox.CENTER_JUSTIFY, MOAITextBox.CENTER_JUSTIFY)
  
  textLayer:insertProp(textboxMetalValue)
  textLayer:insertProp(textboxTechValue)
  textLayer:insertProp(textboxTimeValue)
  textLayer:insertProp(textboxNameValue)
  textLayer:setPriority(1001)
  
  local upgrade = shipUpgradesList[1]
  SetBuildButtonVisibility(upgrade)
  textboxNameValue:setString(""..upgrade:GetName())
  textboxMetalValue:setString(""..upgrade:GetRequiredMetal())
  textboxTechValue:setString(""..upgrade:GetRequiredTech())
  textboxTimeValue:setString(""..upgrade:GetRequiredTime())
  
  propBackButton.name = "leaveUpgradeScreen"
  propBuildButton.name = "buildUpgrade"
  gamestate = "upgrading"
end

function endOfBattle(winningTeam, loot)
  
  clearLayers()
  textureGoMenu = MOAIImage.new()
  textureGoMenu:load("resources/play_button.png")
  
  spriteGoMenu = MOAIGfxQuad2D.new()
	spriteGoMenu:setTexture(textureGoMenu)
	spriteGoMenu:setRect(-8, -8, 8, 8)
  
  propGoMenu = MOAIProp2D.new()
	propGoMenu:setDeck(spriteGoMenu)
	propGoMenu:setLoc(-130,-70)
  propGoMenu:setBlendMode( MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA )
  propGoMenu:setPriority(1000)
  propGoMenu.name = "button"
  
  --endweekLayer:insertProp(propButton)
  
  amountOfLoot = loot
  MOAIRenderMgr.pushRenderPass(endweeklayer)
  if(team == 1) then
    textboxBattleResults = CreateTextBox(-75, 50, 150, 100, upgradeMenuStyle,
      "The left team has lost this battle, you gained "..amountOfLoot.." metal")
    userdata.metal = loot
    save_userdata()
  else
     textboxBattleResults = CreateTextBox(0, 0, 150, 100, upgradeMenuStyle, 
     "The right team has lost this battle, you gained "..amountOfLoot.." plasma")
   userdata.tech = loot
   save_userdata()
   end
  
  endweeklayer:insertProp(textboxBattleResults)
  endweeklayer:insertProp(propGoMenu)
  
  endOfBattlePartition = MOAIPartition.new()
	endOfBattlePartition:insertProp(propGoMenu)
  endOfBattlePartition:insertProp(textboxBattleResults)
	endweeklayer:setPartition(endOfBattlePartition)
  gamestate = "endOfBattle"
end

function clearLayers()
  universeLayer:clear()
  layer:clear()
  clayer:clear()
  buttonlayer:clear()
  textLayer:clear()
  menuLayer:clear()
  upgradeLayer:clear()
  barlayer:clear()
  baselayer:clear()
  basebarlayer:clear()
  blayer:clear()
  elayer:clear()
  elayer2:clear()
  eblayer:clear()
  ebrlayer:clear()
  endweeklayer:clear()
  upgradeback:clear()
  --killAll()
  MOAISim.forceGarbageCollection()
end
--[[
function killAll()
  
  for i, e in ipairs(enemyList) do
    local c = table.getn(enemyList)
    print(i .. "/" .. c)
    if(e ~= nil and e.prop ~= nil and e.prop.thread ~= nil) then
      e.prop.thread:stop()
      print("1")
    end
    if(e ~= nil and e.prop ~= nil) then
      e.prop = nil
      print("2")
    end
    if(e ~= nil and e.thread ~= nil) then
      e.thread:stop()
      print("3")
    end
    if(e ~= nil) then
      e = nil
      print("4")
    end
    
    local clock = os.clock
    function sleep(n)
      local t0 = clock()
      while clock() - t0 <= n do end
    end
    sleep(0.1)
    print("Done")
  end

  enemyList = {}
  enemyCount = 0
end
--]]
