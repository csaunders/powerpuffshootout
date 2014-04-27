require('shooter')
require('clean_loopable_song')
require('loopable_sprite')
require('sprite_frame_definitions')
require('screen_dimmer')
require('countdown_timer')
require('joystick_wrapper')

minRequiredJoysticks = 2
Assets = {
  ['Audio'] = {
    ['victory'] = love.audio.newSource('Assets/Audio/TOJam2014winnerrocktheme.mp3', 'stream'),
    ['theme']   = love.audio.newSource('Assets/Audio/TOJam2014westernstandoff.mp3', 'stream')
  },
  ['Graphics'] = {
    ['howToPlay'] = love.graphics.newImage('Assets/Art/placeholderInstructions.png'),
    ['background'] = love.graphics.newImage('Assets/Art/background.png'),
    ['replay'] = love.graphics.newImage('Assets/Art/replay.png'),
  }
}
Audio = {
  ['victory'] = CleanLoopableSong.NewSong(0,9.047,32.026,Assets.Audio.victory),
  ['theme']   = CleanLoopableSong.NewSong(0,16.069,64.092,Assets.Audio.theme),
}
Sprites = {
  ['Princess1'] = SpriteFrameDefinitions.Princess1,
  ['Princess2'] = SpriteFrameDefinitions.Princess2,
}
gameDebug = false
playMusic = true
controllersOn = false
currentGameState = 3
gameStateCounter = 0
players = {}
currentSong = nil
bulletSpeed = 4800
player1 = nil
player2 = nil
message = nil

dimmer = ScreenDimmer.NewScreenDimmer(2.0, 2, 0x00, 0x00, 0x00)
countdown = CountdownTimer.ThreeTwoOneDraw()

function love.load(arg)
  if arg[#arg] == "-debug" then
    gameDebug = true
    require("mobdebug").start()
  end

  setSong(Audio.theme)
  count = love.joystick.getJoystickCount()
  initializePlayers(grabJoysticks())
end

function love.keypressed(k, u)
  if k == "escape" then
    love.event.quit()
  elseif k == "r" then
    if anyoneDead() then
      reset()
      currentGameState = 1
    end
  elseif k == "0" then
    dimmer:setDimming(true)
  end
end

function love.update(dt)
  updateCurrentGameState(dt)
  dimmer:update(dt)
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
  love.graphics.draw(Assets.Graphics.background, 0, 0)
  killed = nil
  for i, player in pairs(players) do
    if Bullet.AnyKilling(player) then
      killed = player
      currentSong:stop()
      player:kill()
      dimmer:setDimming(true)
      Bullet.ClearBullets()
    end
    player:draw()
  end
  if killed then
    if killed == player1 then p = player2 else p = player1 end
    p:setFreezeAnimation(true)
  end
  love.graphics.print("Current: " .. currentGameState .. " Timer Value: " .. gameStateCounter, 10, 10)
  Bullet.DrawBullets()
  dimmer:draw()
  DrawOverlay()
end

function grabJoysticks()
  player1Joy, player2Joy = nil, nil
  joysticks = love.joystick.getJoysticks()
  for i, joystick in pairs(joysticks) do
    if joystick:getID() == 1 then
      player1Joy = joystick
    elseif joystick:getID() == 2 then
      player2Joy = joystick
    end
  end
  return player1Joy, player2Joy
end

function initializePlayers(player1Joy, player2Joy)
  wrapper1 = JoystickWrapper.newJoystick(player1Joy, JoystickWrapper.Mappings.Player1)
  wrapper2 = JoystickWrapper.newJoystick(player2Joy, JoystickWrapper.Mappings.Player2)
  player1 = Shooter.BuildShooter(Shooter.RIGHT, "Player 1", wrapper1, Sprites.Princess1)
  player2 = Shooter.BuildShooter(Shooter.LEFT, "Player 2", wrapper2, Sprites.Princess2)
  players = {player1, player2}
end

function reset()
  dimmer:reset()
  countdown:reset()
  for i, player in pairs(players) do
    player:clearState()
  end
  setSong(Audio.theme)
end

function updateCurrentGameState(dt)
  if currentSong then currentSong:update() end
  if gameStates[currentGameState](dt) then
    currentGameState = currentGameState + 1
    gameStateCounter = 0
    if currentGameState == 2 then countdown:handleEvent() end
  end
end

function gameOverlay(dt)
  controllersOn = false
  gameStateCounter = gameStateCounter + dt*300
  return gameStateCounter > 1000
end

function countDown(dt)
  controllersOn = false
  countdown:update(dt)
  return not countdown:checkCountingDown()
end

function play(dt)
  controllersOn = true
  return anyoneDead()
end

function gameover(dt)
  controllersOn = false
  for i, player in pairs(players) do
    if player.joystick:isGamepadDown('back') then
      currentGameState = 0
    elseif player.joystick:isGamepadDown('start') then
      currentGameState = 1
    end
    if currentGameState ~= 4 then reset() end
  end
  return currentGameState ~= 4
end

gameStates = {gameOverlay, countDown, play, gameover}

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
    countdown:draw()
  elseif currentGameState == 4 then
    love.graphics.draw(Assets.Graphics.replay, 0, 0)
  end
  love.graphics.reset()
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

function LogUnhandledEvent(class, event)
  if not event then return end
  print('[' .. class .. '] Unhandled Event: ' .. event)
end
