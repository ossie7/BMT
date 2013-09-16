--
-- Created by IntelliJ IDEA.
-- User: Oswin
-- Date: 3-9-13
-- Time: 19:43
-- To change this template use File | Settings | File Templates.
--
io.output( ):setvbuf("no") -- Fix for console lag

-- Requires
require 'bullet'
require 'fight_helper'
require 'start'
require 'background'

-- TODO: Get gamemode from user choise
loadFightLayers()
loadMenuLayers()

gamemode = NONE
if(gamestate ~= "pause") then
  gamemode = DUEL
end

-- Load main test texture and sprites
texture = MOAIImage.new()
texture:load("resources/thing.png")

truck = MOAIImage.new()
truck:load("resources/truck.png")

crosstexture = MOAIImage.new()
crosstexture:load("cross.png")

guntexture = MOAIImage.new()
guntexture:load("gun.png")

sprite = MOAIGfxQuad2D.new() -- Player
sprite:setTexture(truck)
sprite:setRect(-32,-32,32,32)

bsprite = MOAIGfxQuad2D.new() -- Bullet
bsprite:setTexture(texture)
bsprite:setRect(-8,-8,8,8)

esprite = MOAIGfxQuad2D.new() -- Enemy
esprite:setTexture(texture)
esprite:setRect(-12,-12,12,12)

csprite = MOAIGfxQuad2D.new() -- Crosshair
csprite:setTexture(crosstexture)
csprite:setRect(-8,-8,8,8)

gunsprite = MOAIGfxQuad2D.new()
gunsprite:setTexture(guntexture)
gunsprite:setRect(-8,-8,8,8)


function handleClickOrTouch(x,y)
    prop:setLoc(layer:wndToWorld(x,y))
end

local lastX = 0
local lastY = 0
local clastX = 0
local clastY = 0

function threadDuel () -- DUEL gamemode thread
  startDuel(sprite, layer)
  while true do
    bulletGen(prop:getLoc())
    enemyGenInterval()
    coroutine.yield()
  end
end

function threadChase () -- CHASE gamemode thread
  startChase(sprite, layer)
  while true do
    bulletGen(prop:getLoc())
    enemyGenInterval()
    coroutine.yield()
  end
end

function threadFlee () -- FLEE gamemode thread
  startFlee(sprite, layer)
  newEnemy()
  while true do
    coroutine.yield()
  end
end

function threadBattle () -- BATTLE gamemode thread
  startBattle(sprite, layer)
  while true do
    bulletGen(prop:getLoc())
    enemyGenInterval()
    coroutine.yield()
  end
end

function checkIfInside(locX,locY)
    if (locX < rightborder and locX > leftborder) and (locY < topborder and locY > bottomborder) then
        return true
    else
        return false
    end
end

function newBullet (origX, origY)
    local bullet = Bullet.new(bsprite, blayer, origX, origY, epartition)
    blayer:insertProp(bullet.prop)
    bullet:startThread()
end

-- Start gameloop
thread = MOAIThread.new ()
if(gamemode == DUEL) then
  thread:run(threadDuel)
elseif(gamemode == CHASE) then
  thread:run(threadChase)
elseif(gamemode == FLEE) then
  thread:run(threadFlee)
elseif(gamemode == BATTLE) then
  thread:run(threadBattle)
end

-----------------
function onTouch(x,y)
  
  local hitButton = partition:propForPoint( menuLayer:wndToWorld(x,y) )
  
   if(gamestate == "pause") then
     print(gamestate)
     if hitButton then 
        print(hitButton.name)
        if (hitButton.name == "playing") then
          
          menuLayer:clear()
          
          
          gamemode = DUEL
          thread:run(threadDuel)
          
          lastX, lastY = layer:wndToWorld(x, y*-1)
          
          loadFightLayers()
          gamestate = "playing"
          boolean = WAIT
          playInput()
          
        end
     end
   end
end
--------------------

function onMouseLeftEvent ( down )
    if ( down ) then
        drag = true
    else
        drag = false
    end
    ----
    if (gamestate == "pause") then
      if down then
          
          onTouch(MOAIInputMgr.device.pointer:getLoc())  
      end
    end
    -------
end

function onMove ( x, y )
  ax, ay = layer:wndToWorld(x, y*-1)
  if ( drag and ax <= -100) then
    local deltaY = (ay - lastY) * -1
    prop:moveLoc (0, deltaY, 0, 0, MOAIEaseType.FLAT )
  elseif(drag and ax >= 100) then
  end
  if(ax <= -100) then
    lastX = ax
    lastY = ay
  elseif(ax >= 100) then
    clastX = ax
    clastY = ay
  end
  moveGun(gun, prop, cross)
end

local touchX = 0
local touchY = 0
local ctouchX = 0
local ctouchY = 0
function touchMove( x, y, event)
  ax, ay = layer:wndToWorld(x, y*-1)
if (event == 1 and ax <= -100) then
local deltaX = 0
    local deltaY = ay - touchY
    prop:moveLoc ( deltaX, deltaY*-1, 0, 0, MOAIEaseType.FLAT )
    local gx, gy = prop:getLoc()
    gun:setLoc(gx+14,gy)
    local cx, cy = cross:getLoc()
    gun:setRot(angle(gx+14,gy,cx,cy))
elseif(event == 1 and ax >= 100) then
    local deltaX = 0
    local deltaY = ay - ctouchY
    cross:moveLoc ( deltaX, deltaY*-1, 0, 0, MOAIEaseType.FLAT )
    local gx, gy = gun:getLoc()
    local cx, cy = cross:getLoc()
    gun:setRot(angle(gx,gy,cx,cy))
  end
if(ax <= -100) then
    touchX = ax
    touchY = ay
  elseif(ax >= 100) then
    ctouchX = ax
    ctouchY = ay
  end
end

if MOAIInputMgr.device.pointer then
  MOAIInputMgr.device.mouseLeft:setCallback ( onMouseLeftEvent )
else
  MOAIInputMgr.device.touch:setCallback (
    function ( eventType, idx, x, y, tapCount )
      if (gamestate == "pause") then
        onTouch(x, y)
      else
        touchMove ( x, y, eventType )
      end
    end
    )
end

function playInput()
  if MOAIInputMgr.device.pointer then
    MOAIInputMgr.device.mouseLeft:setCallback ( onMouseLeftEvent )
    if(gamestate == "playing") then
      MOAIInputMgr.device.pointer:setCallback ( onMove )
    end
  end  
end


