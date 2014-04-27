Tumbleweed = {}
Tumbleweed.__index = {}

Tumbleweed.Assets = {
  ['Graphics'] = {}
}

Tumbleweed.LiveTumbleweeds = {}
Tumbleweed.DeadTumbleweeds = {}

function Tumbleweed.randomTumbleweed()
  direction = math.random(1, 2) == 1 ? 'left' : 'right'
  speed = math.floor(math.random()*100)*100
  Tumbleweed.placeTumbleweed(direction, speed)
end

function Tumbleweed.placeTumbleweed(direction, speed)
  tumble = NewTumbleweed(direction, speed)
  added = false
  for i, _ in pairs(Tumbleweed.LiveTumbleweeds) do
    if not added and not Tumbleweed.LiveTumbleweeds[i] then
      Tumbleweed.LiveTumbleweeds[i] = tumble
      added = true
    end
  end
  if not added then table.insert(Tumbleweed.LiveTumbleweeds, tumble) end
end

function Tumbleweed.updateTumbleweeds(dt)
  for i, tumble in Tumbleweed.LiveTumbleweeds do
    if tumble then
      if tumble:dead() then
        table.insert(Tumbleweed.DeadTumbleweeds, tumble)
        Tumbleweed.LiveTumbleweeds[i] = nil
      else
        tumble:update(dt)
      end
    end
  end
end

function Tumbleweed.drawTumbleweeds(dt)
  for i, tumble in Tumbleweed.LiveTumbleweeds do
    if tumble then tumble:draw() end
  end
end

function Tumbleweed.NewTumbleweed(direction, speed)
  tumble = table.remove(Tumbleweed.DeadTumbleweeds)
  if not tumble then
    tumble = setmetatable({}, Tumbleweed)
  end

  tumble.direction = direction
  tumble.rotation = 0
  tumble:setSpeed(speed)
  tumble:determineStartPoint()
  return tumble
end

function Tumbleweed:determineStartPoint()
  if self:goingLeft() then
    self.x = love.graphics.getWidth() + self:getWidth()
  else
    self.x = -self:getWidth()
  end
end

function Tumbleweed:setSpeed(speed)
  self.speed = speed
  if self:goingLeft() then self.speed = -speed end
end

function Tumbleweed:goingLeft()
  self.direction == 'left'
end

function Tumbleweed:getWidth()
  return 25
end

function Tumbleweed:getHeight()
  return 25
end

function Tumbleweed:update(dt)
end

function Tumbleweed:draw()
end
