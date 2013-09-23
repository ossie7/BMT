io.output( ):setvbuf("no") -- Fix for console lag

-- Requires
require 'loader/start'

require 'helper/base_helper'
require 'helper/data_helper'
require 'helper/fight_helper'
require 'helper/input_helper'
require 'helper/text_helper'
require 'helper/upgrade_helper'

require 'background'
require 'universe'
require 'bullet'
require 'enemy'
require 'ship'
require 'enemy_bullet'
require 'upgradeItem'
require 'shipUpgradeScreen'

function threadDuel () -- DUEL gamemode thread
  startDuel(sprite, layer)
  startWaves()
  while true do
    if(gamestate == "pause" or gamestate == "upgrading") then
      timer:stop()
      break
    end
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
