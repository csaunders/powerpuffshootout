Bullet = {
  LEFT = 5,
  RIGHT = 6
}
Bullet.__index = Bullet

Bullet.Assets = {
  ['Audio'] = {
    ['Shot'] = love.audio.newSource('Assets/Audio/TOJAM2014 Gun2.mp3', 'static'),
    ['Ricochet'] = love.audio.newSource('Assets/Audio/ricochet.wav', 'static')
  },
  ['Visual'] = {
  }
}

Bullet.LiveBullets = {}
Bullet.DeadBullets = {}

function Bullet.FireBullet(x, y, direction, speed)
  bullet = Bullet.NewBullet(x, y)
  if direction == Bullet.LEFT then
    bullet.vx = -speed
    bullet.x = bullet.x - (bullet:getWidth() + 1)
  elseif direction == Bullet.RIGHT then
    bullet.vx = speed
    bullet.x = bullet.x + (bullet:getWidth() + 1)
  end
  Bullet.placeLiveBullet(bullet)
end

function Bullet.placeLiveBullet(bullet)
  added = false
  for i, bullet in pairs(Bullet.LiveBullets) do
    if not added and Bullet.LiveBullets[i] == nil then
      Bullet.LiveBullets[i] = bullet
      added = true
    end
  end
  if not added then table.insert(Bullet.LiveBullets, bullet) end
end

function Bullet.UpdateBullets(dt)
  for i, bullet in pairs(Bullet.LiveBullets) do
    if bullet then
      if bullet:dead() then
        bullet.ricochet:stop()
        bullet.ricochet:play()
        table.insert(Bullet.DeadBullets, bullet)
        Bullet.LiveBullets[i] = nil
      else
        bullet:update(dt)
      end
    end
  end
end

function Bullet.AnyKilling(player)
  x, y, w, h = player:bindingBox()
  for i, bullet in pairs(Bullet.LiveBullets) do
    bx, by, bw, bh = bullet:bindingBox()
    colliding = CheckCollision(x,y,w,h,bx,by,bw,bh)
    if colliding and not player:blocksImpact() then
      table.insert(Bullet.DeadBullets, bullet)
      Bullet.LiveBullets[i] = nil
      return true
    end
  end
  return false
end

function Bullet.DrawBullets()
  for i, bullet in pairs(Bullet.LiveBullets) do
    if bullet then bullet:draw() end
  end
end

function Bullet.NewBullet(x, y)
  bullet = table.remove(Bullet.DeadBullets)
  if bullet == nil then
    bullet = setmetatable({}, Bullet)
    bullet.shot = Bullet.Assets.Audio.Shot:clone()
    bullet.ricochet = Bullet.Assets.Audio.Ricochet:clone()
  end

  bullet.x = x
  bullet.y = y
  bullet.shot:stop()
  bullet.shot:play()
  return bullet
end

function Bullet.ClearBullets()
  for i, bullet in pairs(Bullet.LiveBullets) do
    table.insert(Bullet.DeadBullets, bullet)
  end
  Bullet.LiveBullets = {}
end

function Bullet:bindingBox()
  return self.x, self.y, self:getWidth(), self:getHeight()
end

function Bullet:update(dt)
  self.x = self.x + dt*self.vx
end

function Bullet:draw()
  love.graphics.setColor(255, 255, 0)
  love.graphics.rectangle('fill', self.x, self.y, self:getWidth(), self:getHeight())
  love.graphics.reset()
end

function Bullet:getWidth()
  return 5
end

function Bullet:getHeight()
  return 5
end

function Bullet:dead()
  return self.x < 0 or self.x > love.graphics.getWidth()
end

