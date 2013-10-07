function GetEnemyAnimationProp(team, ship)
  local prop = MOAIProp2D.new()
  
  if team == 1 and ship == 1 then
    prop:setDeck(blueDroneTileLib)
  elseif team == 1 and ship == 3 then
    prop:setDeck(blueTankTileLib)
  end
  
  return prop
end

function GetEnemyAnimation(prop, team, ship)
  local frames;
  local curve = MOAIAnimCurve.new()
  
  if team == 1 and ship == 1 then
    frames = 13
    curve:reserveKeys(frames)
  elseif team == 1 and ship == 3 then
    frames = 3
    curve:reserveKeys(frames)
  end
  
  for i = 1, frames, 1 do
    -- index, time, hoeveelste plaatje
    curve:setKey(i, 0.05 * i, i)
  end
  
  local anim = MOAIAnim.new()
  anim:reserveLinks(1) -- aantal curves
  anim:setLink(1, curve, prop, MOAIProp2D.ATTR_INDEX)
  anim:setMode(MOAITimer.LOOP)
  anim:setSpan(frames * 0.05)
  
  return anim
end

function GetEnemyGun(team, ship, x, y)
  local gun = MOAIProp2D.new()
  
  if team == 1 and ship == 1 then
    gun:setDeck(blueDroneGun)
  elseif team == 1 and ship == 3 then
    gun:setDeck(blueTankGun)
  else
    gun:setDeck(gunsprite)
  end
  
  gun:setLoc(x, y)
  gun:setBlendMode(MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA)
  
  return gun
end
