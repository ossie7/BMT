--
-- Created by IntelliJ IDEA.
-- User: Oswin
-- Date: 3-9-13
-- Time: 19:43
-- To change this template use File | Settings | File Templates.
--
io.output( ):setvbuf("no")

require 'bullet'
require 'helper'
require 'start'

gamemode = DUEL

texture = MOAIImage.new()
texture:load("thing.png")

sprite = MOAIGfxQuad2D.new()
sprite:setTexture(texture)
sprite:setRect(-16,-16,16,16)

msprite = MOAIGfxQuad2D.new()
msprite:setTexture(texture)
msprite:setRect(-8,-8,8,8)

esprite = MOAIGfxQuad2D.new()
esprite:setTexture(texture)
esprite:setRect(-12,-12,12,12)

prop = MOAIProp2D.new()
prop:setDeck(sprite)
--prop:setLoc(0,0)
layer:insertProp(prop)

MOAIGfxDevice.getFrameBuffer():setClearColor(100,0,0,0)

function handleClickOrTouch(x,y)
    prop:setLoc(layer:wndToWorld(x,y))
end

local lastX = 0
local lastY = 0

function wait ( action )
    while action:isBusy () do coroutine:yield () end
end

local clock = os.clock
local last = 0
local laste = 0
local interval = 0.2
local intervale = 1
function threadDuel ()
    prop:setLoc(-100,0)
    while true do
        local locX,locY = prop:getLoc()
        if(last+interval < clock()) then
            newBullet(locX,locY)
            last = clock()
        end
        if(laste+intervale < clock()) then
          newEnemy()
          laste = clock()
        end
        --MOAISim.forceGarbageCollection()
        coroutine.yield()
    end
end

function threadChase ()
    prop:setLoc(-100,0)
    while true do
        local locX,locY = prop:getLoc()
        if(last+interval < clock()) then
            newBullet(locX,locY)
            last = clock()
        end
        if(laste+intervale < clock()) then
          newEnemy()
          laste = clock()
        end
        coroutine.yield()
    end
end

function threadFlee ()
    prop:setLoc(100,0)
    newEnemy()
    while true do
        --MOAISim.forceGarbageCollection()
        coroutine.yield()
    end
end

function threadBattle ()
    prop:setLoc(-100,0)
    while true do
        local locX,locY = prop:getLoc()
        if(last+interval < clock()) then
            newBullet(locX,locY)
            last = clock()
        end
        if(laste+intervale < clock()) then
          newEnemy()
          laste = clock()
        end
        --MOAISim.forceGarbageCollection()
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
    local bullet = Bullet.new(msprite, blayer, origX, origY, epartition)
    blayer:insertProp(bullet.prop)
    bullet:startThread()
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

