Tumbleweed = {}
Tumbleweed.__index = Tumbleweed

Tumbleweed.Assets = {
  ['Graphics'] = {
    ['tumbleweed'] = love.graphics.newImage('Assets/Art/tumbleweed.png')
  }
}

Tumbleweed.LiveTumbleweeds = {}
Tumbleweed.DeadTumbleweeds = {}

function Tumbleweed.randomTumbleweed()
  if table.getn(Tumbleweed.LiveTumbleweeds) > 1 then return end
  if math.random() > 0.9 then return end
  direction = (math.random(1, 2) == 1) and 'left' or 'right'
  speed = 150
  Tumbleweed.placeTumbleweed(direction, speed)
end

function Tumbleweed.placeTumbleweed(direction, speed)
  tumble = Tumbleweed.NewTumbleweed(direction, speed)
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
  Tumbleweed.randomTumbleweed()
  for i, tumble in pairs(Tumbleweed.LiveTumbleweeds) do
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

function Tumbleweed.drawTumbleweeds()
  for i, tumble in pairs(Tumbleweed.LiveTumbleweeds) do
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
  tumble.rollingTime = 0
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
  self.offsetY = 0
  self.y = love.graphics.getHeight() - self:getHeight()/2
end

function Tumbleweed:setSpeed(speed)
  self.speed = speed
  if self:goingLeft() then
    self.speed = -speed
  end
end

function Tumbleweed:goingLeft()
  return self.direction == 'left'
end

function Tumbleweed:dead()
  if self:goingLeft() then
    return self.x < -self:getWidth()
  else
    return self.x > love.graphics.getWidth() + self:getWidth()
  end
end

function Tumbleweed:getWidth()
  return Tumbleweed.Assets.Graphics.tumbleweed:getWidth()
end

function Tumbleweed:getHeight()
  return Tumbleweed.Assets.Graphics.tumbleweed:getHeight()
end

function Tumbleweed:update(dt)
  self.rollingTime = self.rollingTime + dt
  self.x = self.x + self.speed*dt
  self.offsetY = -math.abs(math.cos(self.x/50) * 25)
  self.rotation = math.pi*self.rollingTime
  if self:goingLeft() then self.rotation = -self.rotation end
end

function Tumbleweed:draw()
  love.graphics.draw(Tumbleweed.Assets.Graphics.tumbleweed, self.x, self.y + self.offsetY, self.rotation, 1, 1, self:getWidth()/2, self:getHeight()/2)
end
