function bulletGen(x, y)
  if(last+interval < clock()) then
    newBullet(x,y)
    last = clock()
  end
end

function shipThread()
  while true do
    if(gamestate == "pause") then
      break
    end
    bulletGen(prop:getLoc())
    coroutine.yield()
  end
end

function startShipThread ()
  shipthread = MOAICoroutine.new()
  shipthread:run(shipThread)
end
