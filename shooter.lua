require('bullet')
Shooter = {
  IDLE = 1,
  BLOCKING = 2,
  SHOOTING = 3,
  RELOADING = 4,
  LEFT = 5,
  RIGHT = 6,
  DEAD = 7,
  BULLET_CAP = 3,
  STRENGTH_DECAY = 125,
  STRENGTH_REGEN = 5,
  MAX_STRENGTH = 100
}
Shooter.MAPPINGS = {
    ['a'] = Shooter.SHOOTING,
    ['x'] = Shooter.BLOCKING,
    ['y'] = Shooter.RELOADING
}
Shooter.ASSETS = {
  [Shooter.IDLE]      = love.graphics.newImage('Assets/Art/placeholderIdle.png'),
  [Shooter.BLOCKING]  = love.graphics.newImage('Assets/Art/placeholderShield.png'),
  [Shooter.SHOOTING]  = love.graphics.newImage('Assets/Art/placeholderFire.png'),
  [Shooter.RELOADING] = love.graphics.newImage('Assets/Art/placeholderIdle.png'),
  [Shooter.DEAD]      = love.graphics.newImage('Assets/Art/placeholderDead.png'),
}

Shooter.DIMENSIONS = {
  ['offsetX'] = Shooter.ASSETS[Shooter.IDLE]:getWidth()/3,
  ['offsetY'] = Shooter.ASSETS[Shooter.IDLE]:getHeight()/2,
  ['width'] = Shooter.ASSETS[Shooter.IDLE]:getWidth(),
  ['height'] = Shooter.ASSETS[Shooter.IDLE]:getHeight()
}
Shooter.__index = Shooter

function Shooter.BuildShooter(facing, name, joystick)
  local width = love.graphics.getWidth()
  local height = love.graphics.getHeight()
  if facing == Shooter.RIGHT then
    x = Shooter.DIMENSIONS.offsetX
  else
    x = width - (Shooter.DIMENSIONS.offsetX)
  end
  y = height - Shooter.DIMENSIONS.offsetY
  return Shooter.NewShooter(x, y, joystick, facing, name or 'Stubbed')
end

function Shooter.NewShooter(x, y, joystick, facing, name)
  local self = setmetatable({}, Shooter)
  self:clearState()

  self.position = {
    ['x'] = x, ['y'] = y,
    ['handX'] = 0, ['handY'] = 0
  }
  self.joystick = joystick
  self.facing = facing
  self.name = name
  if facing == Shooter.LEFT then
    self.scalex = 1
  else
    self.scalex = -1
  end

  return self
end

function Shooter.determineState(joystick)
  current_state = Shooter.IDLE
  for key, state in pairs(Shooter.MAPPINGS) do
    if joystick:isGamepadDown(key) then
      current_state = state
    end
  end
  return current_state
end

function Shooter:clearState()
  self.state = Shooter.IDLE
  self.bulletsLeft = Shooter.BULLET_CAP
  self.strength = Shooter.MAX_STRENGTH
end

function Shooter:setColor()
  r, g, b = 255, 255, 255
  if self:isShooting() then
    g, b = 0, 0
  elseif self:isReloading() then
    r, g = 0, 0
  elseif self:blocksImpact() then
    r, b = 0, 0
  end
  love.graphics.setColor(r, g, b)
end

function Shooter:setSprite()
  self.sprite = Shooter.ASSETS[self.state]
end

function Shooter:update(dt)
  if self.name == 'Stubbed' then return end
  self.previousState = self.state
  if not self:isDead() then self.state = Shooter.determineState(self.joystick) end
  if self:isBlocking() then
    self.strength = math.max(self.strength - Shooter.STRENGTH_DECAY*dt, 0)
  else
    self.strength = math.min(self.strength + Shooter.STRENGTH_REGEN*dt, Shooter.MAX_STRENGTH)
  end
  self:reload()
end

function Shooter:isMatchingState()
  return self.previousState == self.state
end

function Shooter:isReloading()
  return not self:isMatchingState() and self.state == Shooter.RELOADING
end

function Shooter:isBlocking()
  return self.state == Shooter.BLOCKING
end

function Shooter:blocksImpact()
  return self:isBlocking() and self.strength > 0
end

function Shooter:isShooting()
  return not self:isMatchingState() and self.state == Shooter.SHOOTING
end

function Shooter:isDead()
  return self.state == Shooter.DEAD
end

function Shooter:shoot(speed)
  if self.bulletsLeft > 0 then
    gunX, gunY = self:gunPosition()
    Bullet.FireBullet(gunX, gunY, self.facing, speed)
    self.bulletsLeft = self.bulletsLeft - 1
  end
end

function Shooter:kill()
  self.state = Shooter.DEAD
end

function Shooter:reload()
  if self:isReloading() then
    self.bulletsLeft = Shooter.BULLET_CAP
  end
end

function Shooter:gunPosition()
  x, y, _, _, _, ox, oy = self:drawParams()
  x = x - self.scalex*ox/2
  return x, y - (oy/2 + 10)
end

function Shooter:drawParams()
  x, y = self.position.x, self.position.y
  r, sx, sy = 0, self.scalex, 1
  ox, oy = Shooter.DIMENSIONS.width / 2, Shooter.DIMENSIONS.height / 2
  return  x, y, r, sx, sy, ox, oy
end

function Shooter:bindingBox()
  x, y, _, _, _, ox, oy = self:drawParams()
  if self.facing == Shooter.RIGHT then
    x = x - ox
  end
  return x, (y - oy), Shooter.DIMENSIONS.width/2, Shooter.DIMENSIONS.height
end

function Shooter:draw()
  self:setSprite()
  love.graphics.draw(self.sprite, self:drawParams())
  love.graphics.rectangle('line', self:bindingBox())
  -- love.graphics.rectangle('line', self.position.x, self.position.y, 20, 20)
  love.graphics.print(self.name .. ' current strength ' .. self.strength, self.position.x - 100, self.position.y - 30)
  love.graphics.reset()
end
