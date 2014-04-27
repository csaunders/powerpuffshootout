require('bullet')
require('loopable_sprite')
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
  PERFORMING = 8,
}
Shooter.MAPPINGS = {
    ['a'] = 'shooting',
    ['x'] = 'dodging',
    ['y'] = 'reloading'
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
  ['offsetX'] = 85,
  ['offsetY'] = 128,
  ['width'] = 256,
  ['height'] = 256
}
Shooter.__index = Shooter

function Shooter.BuildShooter(facing, name, joystick, definition)
  local sprite = LoopableSprite.NewSprite(definition)
  local screenWidth, screenHeight = love.graphics.getWidth(), love.graphics.getHeight()
  local width, height = sprite:dimensions()
  if facing == Shooter.RIGHT then
    x = Shooter.DIMENSIONS.offsetX
  else
    x = screenWidth - (Shooter.DIMENSIONS.offsetX)
  end
  y = screenHeight - Shooter.DIMENSIONS.offsetY
  return Shooter.NewShooter(x, y, joystick, facing, name or 'Stubbed', sprite)
end

function Shooter.NewShooter(x, y, joystick, facing, name, sprite)
  local self = setmetatable({}, Shooter)

  self.position = {
    ['x'] = x, ['y'] = y,
    ['handX'] = 0, ['handY'] = 0
  }
  self.sprite = sprite
  self.sprite:setCallback(self:eventHandler())
  self.joystick = joystick
  self.facing = facing
  self.name = name
  if facing == Shooter.LEFT then
    self.scalex = 1
  else
    self.scalex = -1
  end

  self:clearState()
  return self
end

function Shooter:determineState(joystick)
  if joystick:isGamepadDown('b') then
    Shooter.Assets.Audio.click:stop()
    Shooter.Assets.Audio.click:play()
  end
  if self.state ~= Shooter.IDLE then return end

  for key, state in pairs(Shooter.MAPPINGS) do
    if joystick:isGamepadDown(key) then
      self.sprite:setState(state)
      self.state = Shooter.PERFORMING
      break
    end
  end
end

function Shooter:eventHandler()
  return function(name)
    if name == 'animationEnd' then
      self.sprite:setState('idle')
      self.state = Shooter.IDLE
    elseif name == 'fire' then
      self.state = Shooter.SHOOTING
    elseif name == 'dodge' then
      self.state = Shooter.BLOCKING
    elseif name == 'dodgeDone' then
      self.state = Shooter.PERFORMING
    end
  end
end

function Shooter:clearState()
  self.sprite:setState('idle')
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
    self:determineState(self.joystick)
  end
  self.sprite:update(dt)
end

function Shooter:blocksImpact()
  return self.state == Shooter.BLOCKING
end

function Shooter:isShooting()
  return self.state == Shooter.SHOOTING
end

function Shooter:isDead()
  return self.state == Shooter.DEAD
end

function Shooter:isPerforming()
  return self.state == Shooter.PERFORMING
end

function Shooter:cannotAct()
  return self:isDead() or self:isPerforming()
end

function Shooter:shoot(speed)
  self.state = Shooter.PERFORMING
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
  ox, oy = self.sprite:dimensions()
  ox, oy = ox/2, oy/2
  return  x, y, r, sx, sy, ox, oy
end

function Shooter:bindingBox()
  x, y, _, _, _, ox, oy = self:drawParams()
  return x - ox/2, (y - oy), Shooter.DIMENSIONS.width/2, Shooter.DIMENSIONS.height
end

function Shooter:drawSprite()
  self.sprite:draw(self:drawParams())
end

function Shooter:draw()
  love.graphics.rectangle('line', self:bindingBox())
  if self.state == Shooter.DEAD then love.graphics.setColor(255, 0, 0) end
  self:drawSprite()
  love.graphics.print('Bullets ' .. self.bulletsLeft, self.position.x - 100, self.position.y - 30)
  love.graphics.reset()
end
