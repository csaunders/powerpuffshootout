require('scenes.introduction')
AttractMode = {}

function AttractMode:draw()
end

function AttractMode:keyreleased(key, code)
end

function AttractMode:enter()
  self.colors = {
    {255, 0, 0},
    {0, 255, 0},
    {0, 0, 255}
  }
  self.position = 1
  self.timer = 0
  self.ticks = 0
end

function AttractMode:update(dt)
  self.timer = self.timer + dt
  if self.timer > 1 then
    if self.position == 3 then
      self.position = 1
    else
      self.position = self.position + 1
    end
    self.timer = 0
    self.ticks = self.ticks + 1
  end
  if self.ticks == 5 then
    State.switch(Introduction)
  end
end

function AttractMode:getColor()
  return self.colors[self.position]
end

function AttractMode:draw()
  love.graphics.setColor(self:getColor())
  love.graphics.rectangle('fill', 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
  love.graphics.reset()
end
