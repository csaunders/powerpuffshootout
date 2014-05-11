Introduction = {}
require('scenes.shootout')

function Introduction:keyreleased(key, code)
end

function Introduction:enter()
  self.count = 0
  self.ticks = 0
end

function Introduction:update(dt)
  self.count = self.count + dt
  if self.count > 1 then self.ticks = self.ticks + 1 end
  if self.ticks >= 5 then
    State.switch(Shootout)
  end
end

function Introduction:draw()
  love.graphics.setColor(255, 255, 0)
  love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
  love.graphics.reset()
end
