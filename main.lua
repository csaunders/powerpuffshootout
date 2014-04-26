require('shooter')
require('clean_loopable_song')
require('loopable_sprite')
require('sprite_frame_definitions')

minRequiredJoysticks = 2
Assets = {
  ['Audio'] = {
    ['victory'] = love.audio.newSource('Assets/Audio/TOJam2014winnerrocktheme.mp3', 'stream'),
    ['theme']   = love.audio.newSource('Assets/Audio/TOJam2014westernstandoff.mp3', 'stream')
  }
}
Audio = {
  ['victory'] = CleanLoopableSong.NewSong(0,9.047,32.026,Assets.Audio.victory),
  ['theme']   = CleanLoopableSong.NewSong(0,16.069,64.092,Assets.Audio.theme),
}
playMusic = false
players = {}
currentSong = nil
bulletSpeed = 3000
player1 = nil
player2 = nil
message = nil

function love.load(arg)
  if arg[#arg] == "-debug" then require("mobdebug").start() end

  callback = function(name)
    if not name then return end
    print("Just got the event: " .. name)
  end
  test = LoopableSprite.NewSprite(SpriteFrameDefinitions.Princess1, callback)
  test:setState('dodging')

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
    if anyoneDead() then reset() end
  end
end

function love.update(dt)
  currentSong:update()
  test:update(dt)
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
  test:draw(300, 200, 0, 1, 1, 200, 200)
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

function reset()
  for i, player in pairs(players) do
    player:clearState()
  end
  setSong(Audio.theme)
end

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
