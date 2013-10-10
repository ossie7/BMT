MOAIUntzSystem.initialize()
MOAIUntzSystem.setVolume(1)
backgroundMusic = nil
nextMusic = nil

function csound(file, looping, volume)
  local sound = MOAIUntzSound.new()
  sound:load(file, false)
  sound:setVolume(volume)
  sound:setLooping(looping)
  return sound
end

function initSounds()
  local laserSound1 = csound("resources/sound/laser1.ogg", false, 0.5)
  local laserSound2 = csound("resources/sound/laser2.ogg", false, 0.5)
  laserSounds = {laserSound1, laserSound2}
  
  local explodeSound1 = csound("resources/sound/explode1.ogg", false, 0.5)
  local explodeSound2 = csound("resources/sound/explode2.ogg", false, 0.5)
  local explodeSound3 = csound("resources/sound/explode3.ogg", false, 0.5)
  local explodeSound4 = csound("resources/sound/explode4.ogg", false, 0.5)
  explodeSounds = {explodeSound1, explodeSound2, explodeSound3, explodeSound4}
  
  buySound         = csound("resources/sound/buy.ogg",          false, 0.5)
  cloakSound       = csound("resources/sound/cloak.ogg",        false, 0.5)
  fullReflectSound = csound("resources/sound/full_reflect.ogg", false, 0.5)
  hitSound         = csound("resources/sound/hit.ogg",          false, 0.2)
  nukeSound        = csound("resources/sound/nuke.ogg",         false, 0.5)
  reflectSound     = csound("resources/sound/reflect.ogg",      false, 0.5)
  regenSound       = csound("resources/sound/regen.ogg",        false, 0.5)
  regenPowerSound  = csound("resources/sound/regen_power.ogg",  false, 0.5)
  
  battleMusic = csound("resources/sound/battle.ogg", true, 1)
  menuMusic = csound("resources/sound/menu.ogg", true, 1)
  
  startMusicThread()
end

function laserSound()
  laserSounds[math.random(1,2)]:play()
end

function explodeSound()
  explodeSounds[math.random(1,4)]:play()
end

function backgroundSound(track)
  if(backgroundMusic == nil) then
    backgroundMusic = track
    backgroundMusic:play()
  elseif(backgroundMusic ~= track or (nextMusic ~= track and nextMusic ~= nil)) then
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
