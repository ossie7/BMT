function CreateTextBox(x, y, width, height, textStyle, text)
  textbox = MOAITextBox.new()
	textbox:setStyle(textStyle)
	textbox:setRect(-(width / 2), -(height / 2), width / 2, height / 2)
  textbox:setLoc(x, y)
	textbox:setYFlip(true)
  textbox:setString(text)
  
  return textbox
end
