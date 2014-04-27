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
  self.color = definition.color
  self.nextFrame = definition.next
  return self
end

function SpriteFrame:getWidth()
  return self.image:getWidth()
end

function SpriteFrame:getHeight()
  return self.image:getHeight()
end

function SpriteFrame:didFrameEnd(duration)
  return duration >= self.duration
end
