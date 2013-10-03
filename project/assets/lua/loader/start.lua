require 'loader/layermgr'
require 'loader/texturemgr'
require 'loader/soundmgr'
require 'loader/styles'

screenWidth  = nil
screenHeight = nil
screenWidthScale = 320
screenHeightScale = 180
if MOAIEnvironment.OS_BRAND_ANDROID then
  screenWidth, screenHeight = MOAIGfxDevice.getViewSize ()
end
print("Starting up on:" .. MOAIEnvironment.osBrand  .. " version:" .. MOAIEnvironment.osVersion)

if screenWidth  == nil or screenWidth  == 0 then screenWidth  = 320 end
if screenHeight == nil or screenHeight == 0 then screenHeight = 180 end

MOAISim.openWindow("\"THE THIRD\"",screenWidth,screenHeight)

viewport = MOAIViewport.new()
viewport:setSize(screenWidth, screenHeight)
viewport:setScale(screenWidthScale, screenHeightScale)

leftborder = (screenWidthScale / 2) * -1
rightborder = screenWidthScale / 2
topborder = screenHeightScale / 2
bottomborder = (screenHeightScale / 2) * -1

initSounds()
initTextures()
initLayers()


CreateShipUpgradesList()
CreateStationUpgradesList()

coins = 0
gamestate = 'pause'
