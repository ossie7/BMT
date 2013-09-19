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

require 'helper/base_helper'
require 'helper/data_helper'
require 'helper/fight_helper'
require 'helper/input_helper'
require 'helper/upgrade_helper'

require 'background'
require 'bullet'
require 'enemy'
require 'ship'
require 'enemy_bullet'


function threadDuel () -- DUEL gamemode thread
  startDuel(sprite, layer)
  while true do
    if(gamestate == "pause") then
      break
    end
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

-- Start gameloop
thread = MOAIThread.new ()
if(gamestate == 'playing') then
  thread:run(threadDuel)
end
