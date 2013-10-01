popupActive = false
currentPopup = nil
popupAction = nil

function addPopup(title, body, button, action)
  MOAIRenderMgr.pushRenderPass(popupLayer)
  MOAIRenderMgr.pushRenderPass(popupButtonLayer)
  MOAIRenderMgr.pushRenderPass(popupTextLayer)
  
  popupActive = true
  popupAction = action
  local popupProp = cprop(popupSprite, 0, 0)
  local popupButtonProp = cprop(popupButtonSprite, 0, -50)
  
  local popupTitle = CreateTextBox(0, 60, 240, 25, style, title)
  popupTitle:setAlignment(MOAITextBox.CENTER_JUSTIFY, MOAITextBox.CENTER_JUSTIFY)
  popupTextLayer:insertProp(popupTitle)
  
  local popupBody = CreateTextBox(0, 0, 240, 50, style12, body)
  popupBody:setAlignment(MOAITextBox.CENTER_JUSTIFY, MOAITextBox.CENTER_JUSTIFY)
  popupTextLayer:insertProp(popupBody)
  
  local popupButtonText = CreateTextBox(0, -47, 80, 26, style, button)
  popupButtonText:setAlignment(MOAITextBox.CENTER_JUSTIFY, MOAITextBox.CENTER_JUSTIFY)
  popupTextLayer:insertProp(popupButtonText)
  
  popupLayer:insertProp(popupProp)
  popupPartition:insertProp(popupButtonProp)
end

function popupClicked()
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
