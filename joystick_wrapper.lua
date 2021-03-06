JoystickWrapper = {}
JoystickWrapper.__index = JoystickWrapper

-- Mappings work like keyboard -> joystick
JoystickWrapper.Mappings = {
  ['Player1'] = {
    ['x'] = 'z',
    ['a'] = 'x',
    ['b'] = 'c',
    ['back'] = 'return',
    ['start'] = '\\',
    ['y'] = ' '
  },
  ['Player2'] = {
    ['x'] = ',',
    ['a'] = '.',
    ['b'] = '/',
    ['back'] = 'return',
    ['start'] = '\\',
    ['y'] = ' '
  }
}

function JoystickWrapper.newJoystick(joystick, keyboardMappings, id)
  local self = setmetatable({}, JoystickWrapper)
  self.joystick = joystick
  self.mappings = keyboardMappings
  self.id = id

  return self
end

function JoystickWrapper:getID()
  if self.joystick then
    return joystick:getID()
  else
    return self.id, self.id
  end
end

function JoystickWrapper:isGamepadDown(button)
  if self.joystick then
    return self.joystick:isGamepadDown(button)
  else
    return self:isKeyboardPressed(button)
  end
end

function JoystickWrapper:down()
  return function(button)
    return self:isGamepadDown(button)
  end
end

function JoystickWrapper:isKeyboardPressed(button)
  key = self.mappings[button]
  return key and love.keyboard.isDown(key)
end

function JoystickWrapper:setVibration(left, right)
  if not self.joystick then return end
  self.joystick:setVibration(left, right)
end
