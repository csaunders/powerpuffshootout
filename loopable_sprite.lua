require('sprite_frame')
LoopableSprite = {}
LoopableSprite.__index = LoopableSprite

function LoopableSprite.NewSprite(definition, callback)
  local self = setmetatable({}, LoopableSprite)
  self.states = {}
  for name, frames in pairs(definition) do
    self.states[name] = SpriteFrame.InitializeFrames(frames)
  end
  self:setCallback(callback)
  return self
end

function LoopableSprite:dimensions()
  -- Ghetto: we assume all frames have the same dimensions
  -- Ghetto: we also assume that all sprites have an idle state
  firstFrame = self.states['idle'][1]
  return firstFrame:getWidth(), firstFrame:getHeight()
end

function LoopableSprite:setCallback(callback)
  self.callback = callback
end

function LoopableSprite:setState(name)
  if not self.states[name] then return end
  self.frames = self.states[name]
  self.currentIndex = 1
  self.currentDuration = 0
end

function LoopableSprite:update(dt)
  if self:didAnimationEnd() then return end

  self.currentDuration = self.currentDuration + dt
  frame = self:currentFrame()
  if frame:didFrameEnd(self.currentDuration) then
    self:fireEvent(frame.event)
    self:nextFrame(frame.nextFrame)
    if self:didAnimationEnd() then
      self:fireEvent('animationEnd')
    end
  end
end

function LoopableSprite:didAnimationEnd()
  return self.currentIndex > table.getn(self.frames)
end

function LoopableSprite:currentFrame()
  return self.frames[self.currentIndex]
end

function LoopableSprite:nextFrame(nextIndex)
  self.currentDuration = 0
  if nextIndex then
    self.currentIndex = nextIndex
  else
    self.currentIndex = self.currentIndex + 1
  end
end

function LoopableSprite:fireEvent(name)
  if not self.callback then return end
  self.callback(name)
end

function LoopableSprite:draw(x, y, r, sx, sy, ox, oy)
  if self:didAnimationEnd() then return end

  frame = self:currentFrame()
  xoffset = frame.xoffset * sx
  love.graphics.draw(frame.image, x+xoffset, y, r, sx, sy, ox, oy)
end
