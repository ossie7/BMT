-- Gamemodes
DUEL   = 1
CHASE  = 2
FLEE   = 3
BATTLE = 4

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

MOAISim.openWindow("Window",screenWidth,screenHeight)

viewport = MOAIViewport.new()
viewport:setSize(screenWidth, screenHeight)
viewport:setScale(screenWidthScale, screenHeightScale)

leftborder = (screenWidthScale / 2) * -1
rightborder = screenWidthScale / 2
topborder = screenHeightScale / 2
bottomborder = (screenHeightScale / 2) * -1

layer = MOAILayer2D.new()
layer:setViewport(viewport)

blayer = MOAILayer2D.new()
blayer:setViewport(viewport)

elayer = MOAILayer2D.new()
elayer:setViewport(viewport)

epartition = MOAIPartition.new()
elayer:setPartition(epartition)

MOAIRenderMgr.pushRenderPass(blayer)
MOAIRenderMgr.pushRenderPass(elayer)
MOAIRenderMgr.pushRenderPass(layer)
