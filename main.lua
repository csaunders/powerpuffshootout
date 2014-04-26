-- 1024 x 576
require('shooter')

minRequiredJoysticks = 1
players = {}
bulletSpeed = 150
player1 = nil
player2 = nil
message = nil

function love.load(arg)
  if arg[#arg] == "-debug" then require("mobdebug").start() end
  if love.joystick.getJoystickCount() == minRequiredJoysticks then
    grabJoysticks()
    message = "You have sufficient controllers"
  else
    message = "You require additional controllers"
  end
end

function love.keypressed(k, u)
  if k == "escape" then
    love.event.quit()
  end
end

function love.update(dt)
  for i, p in pairs(players) do
    p:update(dt)
    if p:isShooting() then
      p:shoot(bulletSpeed)
      bulletSpeed = bulletSpeed + 25
    end
  end
  Bullet.UpdateBullets(dt)
end

function love.draw()
  player1:draw()
  if Bullet.AnyKilling(player1) then
    love.graphics.print("Player 1 has the dead", 600, 400)
  end
  player2:draw()
  if Bullet.AnyKilling(player2) then
    love.graphics.print("Player 2 has the dead", 100, 400)
  end
  Bullet.DrawBullets()
  love.graphics.print(message, 400, 300)
  -- if player1:isGamepadDown("a") then
  --   love.graphics.circle("fill", 100, 100, 50, 100)
  -- end
end

function grabJoysticks()
  width = love.graphics.getWidth()
  height = love.graphics.getHeight()
  joysticks = love.joystick.getJoysticks()
  player1 = Shooter.NewShooter(width - 100, height - 50, joysticks[1], Shooter.LEFT)
  player2 = Shooter.NewShooter(100, height - 50, joysticks[1], Shooter.RIGHT)
  players = {player1, player2}
  -- player1 = joysticks[1]
  -- player2 = joysticks[2]
end

function IsWithinDelta(actual, expected, delta)
  lowerRange = expected-delta
  upperRange = expected+delta
  return actual >= lowerRange and actual <= upperRange
end

function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end
