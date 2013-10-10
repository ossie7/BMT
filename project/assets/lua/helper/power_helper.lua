function initPower()
  power = 0
  maxPower = 100
  powerGen = 1
  lastGen = clock()
  powerActive = false
  powerType = 0
  powerTier = 1
  powerDrain = 0
end

function powerThread()
  while gamestate == "playing" do
    if(popupActive == false) then
      if(lastGen + 1 < clock() and power < maxPower and powerActive == false) then
        powerGen = 1 + (((maxHealth - health) / maxHealth) * 3)
        power = power + powerGen
        if(power > maxPower) then power = maxPower end
        lastGen = clock()
      elseif(powerActive and power <= 0) then
        powerActive = false
      elseif(powerActive) then
        if(lastGen + 1 < clock()) then
          power = power - powerDrain
          lastGen = clock()
          if(power < 0) then power = 0 end
        end
      end
    end
    coroutine.yield()
  end
end

function shipHit()
  if(powerActive) then return end
  powerType = 0
  if(power >= 100 and shipUpgradesList[3]:IsBuild()) then -- Full reflect
    powerActive = true
    powerTier = 3
    powerDrain = 10
    fullReflectSound:play()
  elseif((power >= (100 / 3) * 2) and shipUpgradesList[2]:IsBuild()) then -- Regen + shoot
    powerActive = true
    powerTier = 2
    powerDrain = 7
    regenPowerSound:play()
  elseif((power >= 100 / 3) and shipUpgradesList[1]:IsBuild()) then -- Sniper cloak
    powerActive = true
    powerTier = 1
    powerDrain = 4
    cloakSound:play()
  end
end

function gunHit()
  if(powerActive) then return end
  powerType = 1
  if(power >= 100 and shipUpgradesList[3]:IsBuild()) then -- Nuke
    powerActive = true
    powerTier = 3
    powerDrain = 99
    nukeSound:play()
  elseif((power >= (100 / 3) * 2) and shipUpgradesList[2]:IsBuild()) then -- Rapid shot
    powerActive = true
    powerTier = 2
    powerDrain = 15
  elseif((power >= 100 / 3) and shipUpgradesList[1]:IsBuild()) then -- Spread shot
    powerActive = true
    powerTier = 1
    powerDrain = 5
  end
end

function currentPower(ptype, ptier)
  if(powerActive == false) then return false end
  if(powerType   ~= ptype) then return false end
  if(powerTier   ~= ptier) then return false end
  return true
end

function startPowerThread()
  initPower()
  powerthread = MOAICoroutine.new()
  powerthread:run(powerThread)
end