--
-- Created by IntelliJ IDEA.
-- User: Oswin
-- Date: 3-9-13
-- Time: 19:43
-- To change this template use File | Settings | File Templates.
--
io.output( ):setvbuf("no") -- Fix for console lag

-- Requires
require 'loader/start'
require 'bullet'
require 'helper/fight_helper'
require 'background'
require 'helper/input_helper'

-- TODO: Get gamemode from user choise
loadFightLayers()
loadMenuLayers()


function threadDuel () -- DUEL gamemode thread
  startDuel(sprite, layer)
  while true do
    if(gamestate == "pause") then
      break
    end
    
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
if(gamestate == 'playing') then
  thread:run(threadDuel)
end

-----------------

