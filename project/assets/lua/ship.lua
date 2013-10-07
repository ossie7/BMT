health = 30
maxHealth = 30
bulletDamage = 100
gunActive = false
if(userdata.mission ~= "chased") then
  gunActive = true
end

function checkHealth() 
  return health
end


function newBullet (origX, origY, angle)
  local bestGunBuildIndex = 0
  
  if table.getn(shipUpgradesList) > 0 then
    for i = 1, table.getn(shipUpgradesList), 1 do
      local upgrade = shipUpgradesList[i]
      if upgrade:IsBuild() then
        bestGunBuildIndex = i
      end
    end
  end
  
  local buffedBulletDamage = bulletDamage + (bulletDamage * (bestGunBuildIndex * 0.05))
  if(shipUpgradesList[1]:IsBuild()) then
      bulletDamage = bulletDamage + 100
  end
  
  local bullet = Bullet.new(bsprite, blayer, origX, origY + 2, epartition, angle, bulletDamage)
  bpartition:insertProp(bullet.prop)
  bullet:startThread()
  bullet = nil
end

function bulletGen(x, y, angle)
  if(gunActive) then
    if(last + interval < clock()) then
      laserSound()
      newBullet(x, y, angle)
      last = clock()
    end
  else
    if(last + interval <clock()) then
      health = health + 0.07
      if health > maxHealth then health = maxHealth end
      last = clock()
    end
  end
end

function shipThread()
  while true do
    if(popupActive == false) then
    SetShipColor(1, 1, 1, 1)
    
    if(gamestate ~= "playing") then
      break
    end
    checkBulletCollision()
    local gx, gy = gun:getLoc()
    local cx, cy = cross:getLoc()
    local angle = calcAngle(gx,gy,cx,cy)
    bulletGen(gx, gy, angle)
    end
    coroutine.yield()
  end
end

function startShipThread ()
  health = maxHealth
  if(userdata.mission ~= "chased") then
    gunActive = true
  end
  shipthread = MOAICoroutine.new()
  shipthread:run(shipThread)
end

function checkBulletCollision()
  local x,y = prop:getLoc()
  
  --Hitbox 1
  local hobj1 = ebpartition:propListForRect(x - 24, y - 10, x + 26, y + 2)
  CheckProps(hobj1)
  
  --Reflect
  local robj = ebpartition:propListForRect(x - 26, y - 8, x - 24, y + 2)
  CheckProps(robj, true)
end

function CheckProps(props, reflect)
  local reflectHitbox = reflect or false
  
  if(props) then
    if(type(props) == "table") then
      for i, hit in ipairs(props) do
        if reflectHitbox == false then
          damage(hit)
        elseif(hit.owner.source == 1) then
          newReflectBullet(hit.owner)
          hit.owner:reflect()
        end
      end
    else
      if reflectHitbox == false then
        damage(props)
      elseif(props.owner.source == 1) then
        newReflectBullet(props.owner)
        props.owner:reflect()
      end
    end
  end
end

function newReflectBullet(obullet)
  local a = obullet.angle - 180
  local x, y = obullet.prop:getLoc()
  local bullet = EnemyBullet.new(obullet.sprite, x, y, a, 3, obullet.damage / 2)
  ebrpartition:insertProp(bullet.prop)
  bullet:setScl(1)
  bullet.layer = ebrlayer
  bullet:startThread()
end

function damage(obj)
  obj.thread:stop()
  ebpartition:removeProp(obj)
  ebrpartition:removeProp(obj)
  health = health - 1
  if health < 0 then health = 0 end
  SetShipColor(1, 0, 0, 1)
  if (health <= 0 ) then
    save_userdata()
    addPopup("You died", "You weren't able to keep\nbalance in the war.\nBut the war continues...","Ok","deadShip")
  end
end

function SetShipColor(r, g, b, a)
  prop:setColor(r, g, b, a)
end
