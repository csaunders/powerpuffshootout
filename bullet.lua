Bullet = {
  LEFT = 5,
  RIGHT = 6
}
Bullet.__index = Bullet

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
    if colliding then
      table.insert(Bullet.DeadBullets, bullet)
      Bullet.LiveBullets[i] = nil
      return not player:blocksImpact()
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
  end

  bullet.x = x
  bullet.y = y
  return bullet
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

