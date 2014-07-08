require('shooter')
require('clean_loopable_song')
require('loopable_sprite')
require('sprite_frame_definitions')
require('screen_dimmer')
require('countdown_timer')
require('joystick_wrapper')
require('tumbleweed')

require('scenes.attract_mode')

local lovetest = require('test/lovetest')
State = require('hump.gamestate')

function love.load(arg)
  if arg[#arg] == "-debug" then
    gameDebug = true
    require("mobdebug").start()
  end

  if lovetest.detect(arg) then lovetest.run() end

  State.registerEvents()
  State.switch(AttractMode)
end

function love.keypressed(k, u)
  if k == "escape" then
    love.event.quit()
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

function LogUnhandledEvent(class, event)
  if not event then return end
  print('[' .. class .. '] Unhandled Event: ' .. event)
end
