MOAIUntzSystem.initialize()
MOAIUntzSystem.setVolume(1)
backgroundMusic = nil
nextMusic = nil

function csound(file, looping)
  local sound = MOAIUntzSound.new()
  sound:load(file)
  sound:setVolume(1)
  sound:setLooping(looping)
  return sound
end

function initSounds()
  laserSound1 = csound("resources/sound/laser1.ogg", false)
  laserSound2 = csound("resources/sound/laser2.ogg", false)
  laserSound3 = csound("resources/sound/laser3.ogg", false)
  laserSounds = {laserSound1, laserSound2, laserSound3}
  
  explodeSound1 = csound("resources/sound/explode1.ogg", false)
  explodeSound2 = csound("resources/sound/explode2.ogg", false)
  explodeSounds = {explodeSound1, explodeSound2}
  
  battleMusic = csound("resources/sound/battle.ogg", true)
  menuMusic = csound("resources/sound/menu.ogg", true)
  
  startMusicThread()
end

function laserSound()
  laserSounds[math.random(1,3)]:play()
end

function explodeSound()
  explodeSounds[math.random(1,2)]:play()
end

function backgroundSound(track)
  if(backgroundMusic == nil) then
    backgroundMusic = track
    backgroundMusic:play()
  else
    nextMusic = track
  end
end

function musicThread()
  while true do
    if(nextMusic and backgroundMusic:getVolume() > 0) then
      backgroundMusic:setVolume(backgroundMusic:getVolume() - 0.02)
    end
    if(nextMusic and backgroundMusic:getVolume() <= 0) then
      backgroundMusic:stop()
      backgroundMusic = nextMusic
      nextMusic = nil
      backgroundMusic:setVolume(1)
      backgroundMusic:play()
    end
    coroutine.yield()
  end
end

function startMusicThread()
  musicthread = MOAICoroutine.new()
  musicthread:run(musicThread)
end
