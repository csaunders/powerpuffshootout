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
  ['Graphics'] = {
    ['player2'] = love.graphics.newImage('Assets/Art/Chemo_Bullet.png'),
    ['player1'] = love.graphics.newImage('Assets/Art/p2-bullet.png'),
  }
}

Bullet.LiveBullets = {}
Bullet.DeadBullets = {}

function Bullet.FireBullet(x, y, direction, speed, player)
  bullet = Bullet.NewBullet(x, y, player)
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
  for i, _ in pairs(Bullet.LiveBullets) do
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
    if colliding and not player:dodgesImpact() then
      table.insert(Bullet.DeadBullets, bullet)
      bullet.x = -100
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

function Bullet.NewBullet(x, y, player)
  bullet = table.remove(Bullet.DeadBullets)
  if bullet == nil then
    bullet = setmetatable({}, Bullet)
    bullet.shot = Bullet.Assets.Audio.Shot:clone()
    bullet.ricochet = Bullet.Assets.Audio.Ricochet:clone()
  end

  bullet.x = x
  bullet.y = y
  bullet.image = Bullet.Assets.Graphics[player]
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
  scalex = self.vx > 0 and -1 or 1
  love.graphics.draw(self.image, self.x, self.y, 0, scalex, 1)
  love.graphics.reset()
end

function Bullet:getWidth()
  return self.image:getWidth()
end

function Bullet:getHeight()
  return self.image:getWidth()
end

function Bullet:dead()
  return self.x < 0 or self.x > love.graphics.getWidth()
end

