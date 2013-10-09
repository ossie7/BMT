maxSnipersActivePerSide = 2
maxTanksActivePerSide = 1
leftTeamTanksAmount = 0
leftTeamSnipersAmount = 0
rightTeamTanksAmount = 0
rightTeamSnipersAmount = 0

function GenerateShip(team)
  local ship = math.random(1, 3)
  
  --left team restrictions
  if team == 1 and ship == 2 and userdata.turn >= 5 then
    if leftTeamSnipersAmount >= maxSnipersActivePerSide then
      ship = 1
    else
      leftTeamSnipersAmount = leftTeamSnipersAmount + 1
    end
  elseif team == 1 and ship == 2 then
    ship = 1
  end
  
  if team == 1 and ship == 3 and userdata.turn >= 7 then
    if leftTeamTanksAmount >= maxTanksActivePerSide then
      ship = 1
    else
      leftTeamTanksAmount = leftTeamTanksAmount + 1
    end
  elseif team == 1 and ship == 3 then
    ship = 1
  end
  
  --right team restrictions
  if team == 2 and ship == 2 and userdata.turn >= 5 then
    if rightTeamSnipersAmount >= maxSnipersActivePerSide then
      ship = 1
    else
      rightTeamSnipersAmount = rightTeamSnipersAmount + 1
    end
  elseif team == 2 and ship == 2 then
    ship = 1
  end
  
  if team == 2 and ship == 3 and userdata.turn >= 7 then
    if rightTeamTanksAmount >= maxTanksActivePerSide then
      ship = 1
    else
      rightTeamTanksAmount = rightTeamTanksAmount + 1
    end
  elseif team == 2 and ship == 3 then
    ship = 1
  end
  
  return ship
end

function GetEnemyAnimationProp(team, ship)
  local prop = MOAIProp2D.new()
  
  if team == 1 and ship == 1 then
    prop:setDeck(blueDroneTileLib)
  elseif team == 1 and ship == 2 then
    prop:setDeck(blueSniper)
  elseif team == 1 and ship == 3 then
    prop:setDeck(blueTankTileLib)
  elseif team == 2 and ship == 1 then
    prop:setDeck(redDroneTileLib)
  elseif team == 2 and ship == 2 then
    prop:setDeck(redSniper)
  elseif team == 2 and ship == 3 then
    prop:setDeck(redTank)
  end
  
  prop:setBlendMode(MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA)
  return prop
end

function GetEnemyAnimation(prop, team, ship)
  local frames;
  local delay = 0.05
  local curve = MOAIAnimCurve.new()
  
  if team == 1 and ship == 1 then
    frames = 13
  elseif team == 1 and ship == 2 then
    frames = 1
  elseif team == 1 and ship == 3 then
    frames = 3
    delay = 0.20
  elseif team == 2 and ship == 1 then
    frames = 8
    delay = 0.15
  elseif team == 2 and ship == 2 then
    frames = 1
  elseif team == 2 and ship == 3 then
    frames = 1
  end
  
  curve:reserveKeys(frames)
  
  for i = 1, frames, 1 do
    -- index, time, hoeveelste plaatje
    curve:setKey(i, delay * i, i)
  end
  
  local anim = MOAIAnim.new()
  anim:reserveLinks(1) -- aantal curves
  anim:setLink(1, curve, prop, MOAIProp2D.ATTR_INDEX)
  anim:setMode(MOAITimer.LOOP)
  anim:setSpan(frames * delay)
  
  return anim
end

function GetEnemyGun(team, ship, x, y, c)
  local gun = MOAIProp2D.new()
  
  if team == 1 and ship == 1 then
    gun:setDeck(invisGun)
  elseif team == 1 and ship == 2 then
    gun:setDeck(blueSniperGun)
  elseif team == 1 and ship == 3 then
    gun:setDeck(blueTankGun)
  elseif team == 2 and ship == 1 then
    gun:setDeck(invisGun)
  elseif team == 2 and ship == 2 then
    gun:setDeck(redSniperGun)
  elseif team == 2 and ship == 3 and c == 1 then
    gun:setDeck(redTankGun1)
  elseif team == 2 and ship == 3 and c == 2 then
    gun:setDeck(redTankGun2)
  else
    gun:setDeck(gunsprite)
  end
  
  gun:setLoc(x, y)
  gun:setBlendMode(MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA)
  
  return gun
end

function newTarget(team)
  local ot = nil
  if(team == 2) then
    ot = epartition
  else
    ot = epartition2
  end
  local e = ot:propListForRect(-160, -90, 160, 90)
  if(e) then
    if(type(e) == "table") then
      local n = table.getn(e)
      return e[math.random(1,n)]
    else
      return e
    end
  end
end
  
function GetEnemyGunOffset(team, ship, c)
  local offsetX = 0
  local offsetY = 0
  
  if team == 1 and ship == 2 then
    offsetX = 5
  elseif team == 1 and ship == 3 then
    offsetX = 3
    offsetY = -7
  elseif team == 2 and ship == 2 then
    offsetX = -1
    offsetY = 2
  elseif team == 2 and ship == 3 and c == 1 then
    offsetX = 0
    offsetY = 17
  elseif team == 2 and ship == 3 and c == 2 then
    offsetX = 4
    offsetY = -8
  end
  
  return offsetX, offsetY
end
