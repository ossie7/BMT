-- 4. Font.1 nieuwe font aanmaken
font = MOAIFont.new()
font:load("resources/8bitoperator.ttf")

 
charcodes = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 .,!?"

-- font 2. Preload Glyphs (lettertjes die gerenderd zijn als plaatje)
font:preloadGlyphs(charcodes, 14)

style = MOAITextStyle.new()
style:setFont(font)
style:setSize(14)

style12 = MOAITextStyle.new()
style12:setFont(font)
style12:setSize(12)

upgradeMenuStyle = MOAITextStyle.new()
upgradeMenuStyle:setFont(font)
upgradeMenuStyle:setSize(10)