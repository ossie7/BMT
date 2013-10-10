health = 50
maxHealth = 50
bulletDamage = 100
gunActive = false
armVerticalOffset = 5
if(userdata.mission ~= "chased") then
  gunActive = true
end

function newBullet (origX, origY, angle)
  if(shipUpgradesList[1]:IsBuild()) then
      bulletDamage = bulletDamage + 100
  end
  
  local bullet = Bullet.new(bsprite, blayer, origX, origY + 2, epartition, angle, bulletDamage)
  bpartition:insertProp(bullet.prop)
  bullet:startThread()
  bullet = nil
end

function bulletGen(x, y, angle)
  local shootInterval = interval
  
  if currentPower(0, 2) then
    RegenPlayerHealth(regenPowerInterval)
  end
  
  if currentPower(1, 2) then
    shootInterval = rapidFireInterval
  end
  
  if(gunActive) then
    if(last + shootInterval < clock()) then
      laserSound()
      newBullet(x, y, angle)
      if(currentPower(1, 1)) then
        newBullet(x, y, angle+10)
        newBullet(x, y, angle-10)
      end
      if(currentPower(1, 3)) then
        for i = 1, 360, 3 do
          newBullet(x, y, i)
        end
        power = 0
      end
      last = clock()
    end
  else
    RegenPlayerHealth(interval)
  end
end

function RegenPlayerHealth(regenInterval)
  if(last + regenInterval <clock()) then
    health = health + 0.07
    if health > maxHealth then health = maxHealth end
    last = clock()
  end
end

function shipThread()
  while true do
    if(popupActive == false) then
    if(currentPower(0, 1)) then
      SetShipColor(0.5, 0.5, 1, 0.2)
    else
      SetShipColor(1, 1, 1, 1)
    end
    
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
  
  local reflect = false
  if(currentPower(0, 3)) then
    SetShipColor(0, 0.5, 0.5, 1)
    reflect = true
  else
    SetShipColor(1, 1, 1, 1)
  end
  
  --Hitbox 1
  local hobj1 = ebpartition:propListForRect(x - 24, y - 10, x + 26, y + 2)
  CheckProps(hobj1, reflect)
  
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
        else
          if currentPower(0, 3) then
            reflectSound:play()
            newReflectBullet(hit.owner)
            hit.owner:reflect()
          else         
            if(hit.owner.source == 1) then
              reflectSound:play()
              newReflectBullet(hit.owner)
              hit.owner:reflect()
            end
          end
        end
      end
    else
      if reflectHitbox == false then
        damage(props)
      else
          if currentPower(0, 3) then
            reflectSound:play()
            newReflectBullet(props.owner)
            props.owner:reflect()
          else         
            if(props.owner.source == 1) then
              reflectSound:play()
              newReflectBullet(props.owner)
              props.owner:reflect()
            end
          end
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
  hitSound:play()
  obj.thread:stop()
  ebpartition:removeProp(obj)
  ebrpartition:removeProp(obj)
  health = health - (obj.owner.damage/100)
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
