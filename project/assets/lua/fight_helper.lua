
function createSprite(sprite, layer)
  prop = MOAIProp2D.new()
  prop:setDeck(sprite)
  layer:insertProp(prop)
end

function startTimer()
  clock = os.clock -- Create clock
  last = 0         -- Last bullet spawn
  laste = 0        -- Last enemy spawn
  interval = 0.2   -- Bullet interval
  intervale = 1    -- Enemy interval
end

function startDuel(sprite, layer)
  layer:clear()
  createSprite(sprite, layer)
  startTimer()
  prop:setLoc(-100,0)
end

function startChase()
  layer:clear()
  createSprite(sprite, layer)
  startTimer()
  prop:setLoc(-100,0)
end

function startFlee()
  layer:clear()
  createSprite(sprite, layer)
  startTimer()
  prop:setLoc(100,0)
end

function startBattle()
  layer:clear()
  createSprite(sprite, layer)
  startTimer()
  prop:setLoc(-100,0)
end

function bulletGen(x, y)
  if(last+interval < clock()) then
    newBullet(x,y)
    last = clock()
  end
end

function enemyGenInterval()
  if(laste+intervale < clock()) then
    newEnemy()
    laste = clock()
  end
end

function newEnemy ()
  local x, y = 0,0
  if(gamemode == FLEE) then
    x = -100
    y = math.random(bottomborder + 10, topborder - 10)
  elseif(gamemode == DUEL) then
    x = 100
    y = math.random(bottomborder + 10, topborder - 10)  
  elseif(gamemode == BATTLE) then
    x = math.random(10, rightborder - 10)
    y = math.random(bottomborder + 10, topborder - 10)
  elseif(gamemode == CHASE) then
    x = 100
    y = math.random(bottomborder + 10, topborder - 10)
  end
  local enemy = MOAIProp2D.new()
  enemy:setDeck(sprite)
  enemy:setLoc(x, y)
  epartition:insertProp(enemy)
end
