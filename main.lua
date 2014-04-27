require('shooter')
require('clean_loopable_song')
require('loopable_sprite')
require('sprite_frame_definitions')

minRequiredJoysticks = 2
Assets = {
  ['Audio'] = {
    ['victory'] = love.audio.newSource('Assets/Audio/TOJam2014winnerrocktheme.mp3', 'stream'),
    ['theme']   = love.audio.newSource('Assets/Audio/TOJam2014westernstandoff.mp3', 'stream')
  },
  ['Graphics'] = {
    ['howToPlay'] = love.graphics.newImage('Assets/Art/placeholderInstructions.png'),
    ['ready'] = nil,
    ['fight'] = nil
  }
}
Audio = {
  ['victory'] = CleanLoopableSong.NewSong(0,9.047,32.026,Assets.Audio.victory),
  ['theme']   = CleanLoopableSong.NewSong(0,16.069,64.092,Assets.Audio.theme),
}
Sprites = {
  ['Princess1'] = SpriteFrameDefinitions.Princess1,
  ['Princess2'] = SpriteFrameDefinitions.Princess1,
}
playMusic = false
controllersOn = false
currentGameState = 1
gameStateCounter = 0
players = {}
currentSong = nil
bulletSpeed = 4800
player1 = nil
player2 = nil
message = nil

function love.load(arg)
  if arg[#arg] == "-debug" then require("mobdebug").start() end

  setSong(Audio.theme)
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
  elseif k == "r" then
    if anyoneDead() then
      reset()
      currentGameState = 1
    end
  end
end

function love.update(dt)
  updateCurrentGameState(dt)
  Bullet.UpdateBullets(dt)
  if anyoneDead() then
    setSong(Audio.victory)
  end

  for i, p in pairs(players) do
    p:update(dt)
    if p:isShooting() then
      p:shoot(bulletSpeed)
    end
  end
end

function love.draw()
  for i, player in pairs(players) do
    if Bullet.AnyKilling(player) then
      player:kill()
    end
    player:draw()
  end
  love.graphics.print("Current: " .. currentGameState .. " Timer Value: " .. gameStateCounter, 10, 10)
  Bullet.DrawBullets()
  DrawOverlay()
end

function grabJoysticks()
  width = love.graphics.getWidth()
  height = love.graphics.getHeight()
  joysticks = love.joystick.getJoysticks()
  for i, joystick in pairs(joysticks) do
    if not player1 then
      player1 = Shooter.BuildShooter(Shooter.LEFT, "Player 2", joystick, Sprites.Princess1)
    elseif not player2 then
      guid = joystick:getID()
      if player1.joystick:getID() ~= guid then
        player2 = Shooter.BuildShooter(Shooter.RIGHT, "Player 2", joystick, Sprites.Princess2)
      end
    else
      break
    end

  end
  players = {player1, player2}
end

function reset()
  for i, player in pairs(players) do
    player:clearState()
  end
  setSong(Audio.theme)
end

function updateCurrentGameState(dt)
  -- action = 
  if gameStates[currentGameState](dt) then
    currentGameState = currentGameState + 1
    gameStateCounter = 0
  end
end

function gameOverlay(dt)
  controllersOn = false
  love.graphics.setColor(255, 0, 0)
  gameStateCounter = gameStateCounter + dt*300
  return gameStateCounter > 1000
end

function countDown(dt)
  controllersOn = false
  love.graphics.setColor(0, 255, 0)
  gameStateCounter = gameStateCounter + dt*300
  return gameStateCounter > 500
end

function play(dt)
  controllersOn = true
  return false
end

gameStates = {gameOverlay, countDown, play}

function anyoneDead()
  for i, player in pairs(players) do
    if player:isDead() then return true end
  end
  return false
end

function setSong(song)
  if currentSong == song then return end
  if currentSong then
    currentSong:stop()
  end
  currentSong = song
  currentSong:play()
end

function DrawOverlay()
  if currentGameState == 1 then
    love.graphics.draw(Assets.Graphics.howToPlay, 0, 0)
  elseif currentGameState == 2 then
  end
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
