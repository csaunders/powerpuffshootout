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
  SHIELD_UP = 0,
  SHIELD_DOWN = math.pi/2,
  SHIELD_TIMING = 7.5,
  SHIELD_HOLD_TIME = 0.3,
}
Shooter.MAPPINGS = {
    ['a'] = Shooter.SHOOTING,
    ['x'] = Shooter.BLOCKING,
    ['y'] = Shooter.RELOADING
}
Shooter.Assets = {
  [Shooter.IDLE]      = love.graphics.newImage('Assets/Art/placeholderIdle.png'),
  [Shooter.BLOCKING]  = love.graphics.newImage('Assets/Art/placeholderShielding.png'),
  [Shooter.SHOOTING]  = love.graphics.newImage('Assets/Art/placeholderFire.png'),
  [Shooter.RELOADING] = love.graphics.newImage('Assets/Art/placeholderIdle.png'),
  [Shooter.DEAD]      = love.graphics.newImage('Assets/Art/placeholderDead.png'),
  ['shield']          = love.graphics.newImage('Assets/Art/placeholderShield.png'),
  ['Audio']           = {
    ['click']         = love.audio.newSource('Assets/Audio/EmptyClick.wav', 'static'),
    ['death']         = love.audio.newSource('Assets/Audio/TOJAM2014 GunEcho2.mp3', 'static'),
  }
}

Shooter.DIMENSIONS = {
  ['offsetX'] = Shooter.Assets[Shooter.IDLE]:getWidth()/3,
  ['offsetY'] = Shooter.Assets[Shooter.IDLE]:getHeight()/2,
  ['width'] = Shooter.Assets[Shooter.IDLE]:getWidth(),
  ['height'] = Shooter.Assets[Shooter.IDLE]:getHeight()
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

function Shooter:determineState(joystick)
  prospective_states = {}
  for key, state in pairs(Shooter.MAPPINGS) do
    if joystick:isGamepadDown(key) then
      table.insert(prospective_states, state)
    end
  end
  if table.getn(prospective_states) == 1 then
    return table.remove(prospective_states)
  elseif table.getn(prospective_states) == 0 then
    return Shooter.IDLE
  else
    return self.state
  end
end

function Shooter:clearState()
  self.state = Shooter.IDLE
  self.bulletsLeft = Shooter.BULLET_CAP
  self.shieldRotation = Shooter.SHIELD_DOWN
  self.shieldHeldDuration = 0.0
end

function Shooter:setSprite()
  self.sprite = Shooter.Assets[self.state]
end

function Shooter:update(dt)
  if self.name == 'Stubbed' then return end
  self.previousState = self.state

  if not self:isDead() then
    self.state = self:determineState(self.joystick)
  end

  if self:isBlocking() then
    self.shieldRotation = math.max(self.shieldRotation - Shooter.SHIELD_TIMING*dt, Shooter.SHIELD_UP)
  else
    self.shieldRotation = math.min(self.shieldRotation + Shooter.SHIELD_TIMING*dt, Shooter.SHIELD_DOWN)
  end

  self:pullShieldDown(dt)
  self:reload()
end

function Shooter:pullShieldDown(dt)
  if self.state == Shooter.BLOCKING then
    self.shieldHeldDuration = self.shieldHeldDuration + dt
  end
  if not self.pullingShieldDown and self.shieldHeldDuration >= Shooter.SHIELD_HOLD_TIME then
    self:setPullingShieldDown(true)
  elseif self.shieldRotation >= Shooter.SHIELD_DOWN then
    if self.state ~= Shooter.BLOCKING then
      self:setPullingShieldDown(false)
    end
  end
end

function Shooter:setPullingShieldDown(value)
  if value == false then
    self.shieldHeldDuration = 0
  end
  self.pullingShieldDown = value
end

function Shooter:isMatchingState()
  return self.previousState == self.state
end

function Shooter:isReloading()
  return not self:isMatchingState() and self.state == Shooter.RELOADING
end

function Shooter:isBlocking()
  return self.state == Shooter.BLOCKING and not self.pullingShieldDown
end

function Shooter:blocksImpact()
  return self:isBlocking() and IsWithinDelta(self.shieldRotation, Shooter.SHIELD_UP, 0.2)
end

function Shooter:isShooting()
  return not self:isMatchingState() and self.state == Shooter.SHOOTING
end

function Shooter:isDead()
  return self.state == Shooter.DEAD
end

function Shooter:isShieldDown()
  return self.shieldRotation == Shooter.SHIELD_DOWN
end

function Shooter:shoot(speed)
  if self.bulletsLeft > 0 then
    gunX, gunY = self:gunPosition()
    Bullet.FireBullet(gunX, gunY, self.facing, speed)
    self.bulletsLeft = self.bulletsLeft - 1
  else
    Shooter.Assets.Audio.click:stop()
    Shooter.Assets.Audio.click:play()
  end
end

function Shooter:kill()
  Shooter.Assets.Audio.death:stop()
  Shooter.Assets.Audio.death:play()
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

function Shooter:drawSprite()
  love.graphics.draw(self.sprite, self:drawParams())
end

function Shooter:drawShield()
  if self:isShieldDown() then return end
  x, y, _, scalex, scaley, ox, oy = self:drawParams()
  rot = self.shieldRotation
  if self.facing == Shooter.LEFT then
    rot = -rot
    scalex = 1
  end
  love.graphics.draw(Shooter.Assets.shield, x, y, rot, scalex, scaley, ox, oy)
end

function Shooter:draw()
  self:setSprite()
  self:drawSprite()
  self:drawShield()
  love.graphics.print("Shield Held Duration:" .. self.shieldHeldDuration .. 's', self.position.x, 200)
  love.graphics.rectangle('line', self:bindingBox())
  -- love.graphics.rectangle('line', self.position.x, self.position.y, 20, 20)
  love.graphics.print(self.name .. ' shield rot ' .. self.shieldRotation, self.position.x - 100, self.position.y - 30)
  love.graphics.reset()
end
