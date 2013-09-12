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

-- TODO: Get gamemode from user choise
gamemode = DUEL

-- Load main test texture and sprites
texture = MOAIImage.new()
texture:load("thing.png")

sprite = MOAIGfxQuad2D.new() -- Player
sprite:setTexture(texture)
sprite:setRect(-16,-16,16,16)

bsprite = MOAIGfxQuad2D.new() -- Bullet
bsprite:setTexture(texture)
bsprite:setRect(-8,-8,8,8)

esprite = MOAIGfxQuad2D.new() -- Enemy
esprite:setTexture(texture)
esprite:setRect(-12,-12,12,12)

-- Set background colour
MOAIGfxDevice.getFrameBuffer():setClearColor(100,0,0,0)

function handleClickOrTouch(x,y)
    prop:setLoc(layer:wndToWorld(x,y))
end

local lastX = 0
local lastY = 0

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

function onMouseLeftEvent ( down )
    if ( down ) or ( isDown ) then
        drag = true
    else
        drag = false
    end
end

function onMove ( x, y )
  ax, ay = layer:wndToWorld(x, y*-1)
  if ( drag ) then
    local deltaX = 0
    local deltaY = ay - lastY
    prop:moveLoc ( deltaX, deltaY*-1, 0, 0, MOAIEaseType.FLAT )
  end
  lastX = ax
  lastY = ay
end

local touchX = 0
local touchY = 0
function touchMove( x, y, event)
  ax, ay = layer:wndToWorld(x, y*-1)
	if (event == 1) then
		local deltaX = 0
    local deltaY = ay - touchY
    prop:moveLoc ( deltaX, deltaY*-1, 0, 0, MOAIEaseType.FLAT )
	end
	touchX = ax
	touchY = ay
end

if MOAIInputMgr.device.pointer then
    MOAIInputMgr.device.mouseLeft:setCallback ( onMouseLeftEvent )
    MOAIInputMgr.device.pointer:setCallback ( onMove )
else
    MOAIInputMgr.device.touch:setCallback (
        function ( eventType, idx, x, y, tapCount )
            touchMove ( x, y, eventType )
        end
    )
end

