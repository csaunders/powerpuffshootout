LoopableSprite = {}
LoopableSprite.__index = LoopableSprite

function LoopableSprite.NewSprite(definition, callback)
  local self = setmetatable({}, LoopableSprite)
  self.states = {}
  for name, frames in pairs(definition) do
    self.states[name] = SpriteFrame.InitializeFrames(frames)
  end
  self.callback = callback
  return self
end

function LoopableSprite:setState(name)
  self.frames = self.states[name]
  self.currentIndex = 1
  self.currentDuration = 0
end

function LoopableSprite:update(dt)
  self.currentDuration = self.currentDuration + dt
  frame = self:currentFrame()
  if frame:didFrameEnd(self.currentDuration) then
    self:fireEvent(frame.event)
    self:nextFrame(frame.nextFrame)
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
  frame = self:currentFrame()
  if not frame then
    print("frame is nil!!!")
  end
  love.graphics.draw(frame.image, x, y, r, sx, sy, ox, oy)
end

SpriteFrame = {}
SpriteFrame.__index = SpriteFrame

function SpriteFrame.InitializeFrames(frames)
  spriteFrames = {}
  for i, frame in pairs(frames) do
    table.insert(spriteFrames, SpriteFrame.NewFrame(frame))
  end
  return spriteFrames
end

function SpriteFrame.NewFrame(definition)
  local self = setmetatable({}, SpriteFrame)

  self.duration = definition.duration
  self.image = love.graphics.newImage(definition.image)
  self.event = definition.event
  self.nextFrame = definition.next
  return self
end

function SpriteFrame:didFrameEnd(duration)
  return duration >= self.duration
end
