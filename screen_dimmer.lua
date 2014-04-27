ScreenDimmer = {}
ScreenDimmer.__index = ScreenDimmer

function ScreenDimmer.NewScreenDimmer(duration, step, r, g, b)
  local self = setmetatable({}, ScreenDimmer)

  self:reset()
  self.texture, self.width, self.height = ScreenDimmer.makeTexture(r, g, b)
  self.dimmingDuration = duration
  self.step = step

  return self
end

function ScreenDimmer.makeTexture(r, g, b)
  local width, height = love.graphics.getWidth(), love.graphics.getHeight()
  texture = love.graphics.newCanvas(width, height)
  love.graphics.setCanvas(texture)
  love.graphics.setColor(r, g, b)
  love.graphics.rectangle('fill', 0, 0, width, height)
  love.graphics.setCanvas()
  love.graphics.reset()
  return texture, width, height
end

function ScreenDimmer:update(dt)
  if self.currentDimTime >= self.dimmingDuration or not self.dimming then return end
  self.currentDimTime = self.currentDimTime + dt*self.step
end

function ScreenDimmer:reset()
  self.currentDimTime = 0
  self.dimming = false
end

function ScreenDimmer:setDimming(dimming)
  self.dimming = dimming
end

function ScreenDimmer:alpha()
  return (self.currentDimTime / self.dimmingDuration) * 129
end

function ScreenDimmer:draw()
  love.graphics.setColor(255, 255, 255, self:alpha())
  love.graphics.draw(self.texture, 0, 0)
  love.graphics.reset()
end
