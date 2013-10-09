-- 4. Font.1 nieuwe font aanmaken
font = MOAIFont.new()
font:load("resources/fonts/8bitoperator.ttf")

 
charcodes = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 .,!?"

-- font 2. Preload Glyphs (lettertjes die gerenderd zijn als plaatje)
font:preloadGlyphs(charcodes, 14)

style = MOAITextStyle.new()
style:setFont(font)
style:setSize(14)

style15 = MOAITextStyle.new()
style15:setFont(font)
style15:setSize(15)

style12 = MOAITextStyle.new()
style12:setFont(font)
style12:setSize(12)

style11 = MOAITextStyle.new()
style11:setFont(font)
style11:setSize(11)

style10 = MOAITextStyle.new()
style10:setFont(font)
style10:setSize(10)

upgradeMenuStyle = MOAITextStyle.new()
upgradeMenuStyle:setFont(font)
upgradeMenuStyle:setSize(10)

chatboxstyle = MOAITextStyle.new()
chatboxstyle:setFont(font)
chatboxstyle:setSize(8)

function SetTextboxColor(textbox, r, g, b, a)
  textbox:setColor(r, g, b, a)
end