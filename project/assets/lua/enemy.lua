Enemy = {}
Enemy.__index = Enemy

-- syntax equivalent to "MyClass.new = function..."
function Enemy.new(sprite, x, y, team)
  self = setmetatable({}, Enemy)
  self.prop = MOAIProp2D.new()
  self.team = team
  self.prop:setDeck(sprite)
  self.prop:setLoc(x, y)
  self.prop:setBlendMode( MOAIProp.GL_SRC_ALPHA, MOAIProp.GL_ONE_MINUS_SRC_ALPHA )
  return self
end


function Enemy.startThread (self)
  
  function self.prop:moveEnemy(parent)
    while true do
      locX,locY = self:getLoc()
      newY = locY + math.random(-2,2)
      self:setLoc(locX, newY)
      coroutine.yield()
    end
  end

  self.prop.thread = MOAICoroutine.new()
  self.prop.thread:run(self.prop.moveEnemy, self.prop, self)
end


