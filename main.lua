require('shooter')

minRequiredJoysticks = 2
players = {}
bulletSpeed = 3000
player1 = nil
player2 = nil
message = nil

function love.load(arg)
  if arg[#arg] == "-debug" then require("mobdebug").start() end
  count = love.joystick.getJoystickCount()
  if count >= minRequiredJoysticks then
    grabJoysticks()
    message = "You have sufficient controllers"
  else
    message = "You require additional controllers"
    player1 = Shooter.Stub(Shooter.LEFT)
    player2 = Shooter.Stub(Shooter.RIGHT)
    players = {player1, player2}
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
    end
  end
  Bullet.UpdateBullets(dt)
end

function love.draw()
  for i, player in pairs(players) do
    if Bullet.AnyKilling(player) then
      player:kill()
    end
    player:draw()
  end
  Bullet.DrawBullets()
  love.graphics.print(message, 400, 300)
end

function grabJoysticks()
  width = love.graphics.getWidth()
  height = love.graphics.getHeight()
  joysticks = love.joystick.getJoysticks()
  for i, joystick in pairs(joysticks) do
    if not player1 then
      player1 = Shooter.BuildShooter(Shooter.LEFT, "Player1", joystick)
    elseif not player2 then
      guid = joystick:getID()
      if player1.joystick:getID() ~= guid then
        player2 = Shooter.BuildShooter(Shooter.RIGHT, "Player1", joystick)
      end
    else
      break
    end

  end
  players = {player1, player2}
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
