popupActive = false
currentPopup = nil
popupAction = nil
totalPopups = 0
popupCounter = 1
popupArray = {}

function addPopup(title, body, button, action, face)
  MOAIRenderMgr.pushRenderPass(popupLayer)
  MOAIRenderMgr.pushRenderPass(popupButtonLayer)
  MOAIRenderMgr.pushRenderPass(popupTextLayer)
  
  popupActive = true
  popupAction = action
  
  local popupProp = cprop(popupSprite, 0, 0)
  local popupButtonProp = cprop(popupButtonSprite, 0, -50)
  local popupFaceProp
  
  local popupBody
  local popupTitle = CreateTextBox(0, 52, 240, 25, style15, title)
  popupTitle:setAlignment(MOAITextBox.CENTER_JUSTIFY, MOAITextBox.CENTER_JUSTIFY)
  local popupButtonText = CreateTextBox(0, -47, 80, 26, style11, button)
  popupButtonText:setAlignment(MOAITextBox.CENTER_JUSTIFY, MOAITextBox.CENTER_JUSTIFY)
  
  if(face == nil) then
    popupBody = CreateTextBox(0, 0, 240, 60, style12, body)
    popupBody:setAlignment(MOAITextBox.CENTER_JUSTIFY, MOAITextBox.CENTER_JUSTIFY)
  else
    popupFaceProp = cprop(face, -100, 0)
    popupBody = CreateTextBox(20, 0, 240, 60, style12, body)
    popupBody:setAlignment(MOAITextBox.CENTER_JUSTIFY, MOAITextBox.CENTER_JUSTIFY)
  end
  
  popupTextLayer:insertProp(popupTitle)
  popupTextLayer:insertProp(popupBody)
  popupTextLayer:insertProp(popupButtonText)
  popupLayer:insertProp(popupProp)
  if(popupFaceProp ~= nil) then popupLayer:insertProp(popupFaceProp) end
  popupPartition:insertProp(popupButtonProp)
end

function nextPopup()
  local popup = popupArray[popupCounter]
  addPopup(popup.title, popup.body, popup.button, popup.action, popup.face)
  popupCounter = popupCounter + 1
end

function queuePopup(array)
  popupArray = array
  totalPopups = table.getn(array)
  popupCounter = 1
  nextPopup()
end

function popupClicked()
  if(popupCounter <= totalPopups) then
    removePopup()
    nextPopup()
    return
  elseif(popupCounter > totalPopups) then
    popupCounter = 1
    totalPopups = 0
  end
  local f = popupAction
  removePopup()
  if(f ~= nil) then
    _G[f]()
  end
end

function removePopup()
  popupLayer:clear()
  popupButtonLayer:clear()
  popupTextLayer:clear()
  popupActive = false
  currentPopup = nil
  popupAction = nil
end
