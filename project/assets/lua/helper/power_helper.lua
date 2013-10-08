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
      print(power)
    end
    coroutine.yield()
  end
end

function shipHit()
  if(powerActive) then return end
  print("Ship hit")
  powerType = 0
  if(power >= 100) then -- Full reflect
    powerActive = true
    powerTier = 3
    powerDrain = 10
  elseif(power >= (100 / 3) * 2) then -- Regen + shoot
    powerActive = true
    powerTier = 2
    powerDrain = 5
  elseif(power >= 100 / 3) then -- Sniper cloak
    powerActive = true
    powerTier = 1
    powerDrain = 4
  end
end

function gunHit()
  if(powerActive) then return end
  print("Gun hit")
  powerType = 1
  if(power >= 100) then -- Nuke
    powerActive = true
    powerTier = 3
    powerDrain = 30
  elseif(power >= (100 / 3) * 2) then -- Rapid shot
    powerActive = true
    powerTier = 2
    powerDrain = 10
  elseif(power >= 100 / 3) then -- Spread shot
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