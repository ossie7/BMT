-- 4. Font.1 nieuwe font aanmaken
font = MOAIFont.new()
font:load("resources/arial.ttf")
 
charcodes = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 .,!?"

-- font 2. Preload Glyphs (lettertjes die gerenderd zijn als plaatje)
font:preloadGlyphs(charcodes, 10)

style = MOAITextStyle.new()
style:setFont(font)
style:setSize(10)