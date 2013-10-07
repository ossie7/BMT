io.output( ):setvbuf("no") -- Fix for console lag

-- Requires
require 'helper/popup_helper'
require 'helper/save_helper'
require 'helper/base_helper'
require 'helper/data_helper'
require 'helper/enemy_helper'
require 'helper/fight_helper'
require 'helper/input_helper'
require 'helper/text_helper'
require 'helper/upgrade_helper'

require 'popup'
require 'universe'
require 'bullet'
require 'enemy'
require 'ship'
require 'enemy_bullet'
require 'upgradeItem'
require 'upgradesScreen'

require 'loader/start'

function threadDuel () -- DUEL gamemode thread
  startDuel(player, layer)
  while true do
    if(gamestate ~= "playing") then
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
