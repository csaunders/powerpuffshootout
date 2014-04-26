-- 1024 x 576
require('shooter')

minRequiredJoysticks = 1
world = nil
player1 = nil
player2 = nil
message = nil

function love.load(arg)
  if arg[#arg] == "-debug" then require("mobdebug").start() end
  if love.joystick.getJoystickCount() == minRequiredJoysticks then
    setupWorld()
    grabJoysticks()
    message = "You have sufficient controllers"
  else
    message = "You require additional controllers"
  end
end

function love.update(dt)
  player1:update()
  world:update(dt)
end

function love.draw()
  player1:draw()
  love.graphics.print(message, 400, 300)
  -- if player1:isGamepadDown("a") then
  --   love.graphics.circle("fill", 100, 100, 50, 100)
  -- end
end

function grabJoysticks()
  joysticks = love.joystick.getJoysticks()
  player1 = Shooter.NewShooter(200, 200, joysticks[1], world)
  -- player1 = joysticks[1]
  -- player2 = joysticks[2]
end

function setupWorld()
  world = love.physics.newWorld(0, 500, false)
end
