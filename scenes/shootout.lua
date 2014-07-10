require('scorekeeper')

Shootout = {}

minRequiredJoysticks = 2
Assets = {
  ['Audio'] = {
    ['victory'] = love.audio.newSource('/Assets/Audio/TOJam2014winnerrocktheme.mp3', 'stream'),
    ['theme']   = love.audio.newSource('/Assets/Audio/TOJam2014westernstandoff.mp3', 'stream')
  },
  ['Graphics'] = {
    ['howToPlay'] = love.graphics.newImage('/Assets/Art/xbox_Controls.png'),
    ['background'] = love.graphics.newImage('/Assets/Art/background.png'),
    ['replay'] = love.graphics.newImage('/Assets/Art/xbox_menu.png'),
    ['credits'] = love.graphics.newImage('/Assets/Art/credits.png')
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
currentGameState = 1
gameStateCounter = 0
identificationTiming = 0
players = {}
currentSong = nil
bulletSpeed = 4800
player1 = nil
player2 = nil
message = nil

dimmer = ScreenDimmer.NewScreenDimmer(2.0, 2, 0x00, 0x00, 0x00)
countdown = CountdownTimer.ThreeTwoOneDraw()

function Shootout:enter(previous, ...)
  setSong(Audio.theme)
  count = love.joystick.getJoystickCount()
  initializePlayers(grabJoysticks())
end

function Shootout:leave()
end

function Shootout:update(dt)
  identifyPlayers(dt)
  updateCurrentGameState(dt)
  dimmer:update(dt)
  Bullet.UpdateBullets(dt)
  Tumbleweed.updateTumbleweeds(dt)
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

function Shootout:draw()
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
  Bullet.DrawBullets()
  Tumbleweed.drawTumbleweeds()
  Scorekeeper.GetInstance():draw()
  dimmer:draw()
  DrawOverlay()
end

function Shootout:focus(isfocused)
end

function Shootout:keypressed(k, isrepeat)
  if k == "r" then
    if anyoneDead() then
      reset()
      currentGameState = 1
    end
  elseif k == "0" then
    dimmer:setDimming(true)
  end
end

function Shootout:keyreleased(key)
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
  player2 = Shooter.BuildShooter(Shooter.LEFT, "player1", wrapper2, Sprites.Princess1)
  player1 = Shooter.BuildShooter(Shooter.RIGHT, "player2", wrapper1, Sprites.Princess2)
  players = {player1, player2}
  scores = Scorekeeper.GetInstance()
  for _, player in pairs(players) do
    scores:addScoreable(player.name, {['x'] = player.position.x, ['y'] = 25})
  end
end

function reset()
  scored = false
  dimmer:reset()
  countdown:reset()
  for i, player in pairs(players) do
    player:clearState()
  end
  setSong(Audio.theme)
end

function identifyPlayers(dt)
  if identificationTiming < 2 then
    vib = 1
    identificationTiming = identificationTiming + dt
  else
    vib = 0
  end
  player1.joystick:setVibration(vib, 0)
  player2.joystick:setVibration(0, vib)
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
    elseif player.joystick:isGamepadDown('y') then
      gameStateCounter = 0
      return true
    end
    if currentGameState < 4 then reset() end
  end
  return currentGameState ~= 4
end

function credits(dt)
  gameStateCounter = gameStateCounter + dt*500
  if gameStateCounter < 1000 then return end
  controllersOn = false
  for i, player in pairs(players) do
    down = player.joystick:down()
    if down('back') or down('a') or down('b') or down('x') or down('y') then
      currentGameState = 0
    elseif player.joystick:isGamepadDown('start') then
      currentGameState = 1
    end
    if currentGameState < 5 then reset() end
  end
  return currentGameState ~= 5
end

gameStates = {gameOverlay, countDown, play, gameover, credits}

function anyoneDead()
  for i, player in pairs(players) do
    if player:isDead() then
      updateScore()
      return true
    end
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

function updateScore()
  if scored then return end
  scored = true
  for _, player in pairs(players) do
    if player:isDead() == false then
      Scorekeeper.GetInstance():increment(player.name)
      return
    end
  end
end

function DrawOverlay()
  if currentGameState == 1 then
    love.graphics.draw(Assets.Graphics.howToPlay, 0, 0)
  elseif currentGameState == 2 then
    countdown:draw()
  elseif currentGameState == 4 then
    love.graphics.draw(Assets.Graphics.replay, 0, 0)
  elseif currentGameState == 5 then
    love.graphics.draw(Assets.Graphics.credits)
  end
  love.graphics.reset()
end
