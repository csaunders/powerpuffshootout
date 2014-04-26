Shooter = {}
Shooter.__index = Shooter

function Shooter.PrepareArm(x, y, world)
  segments = {}
  local shoulder = love.physics.newBody(world, x, y, 'static')
  shoulder:setMass(100)
  local arm = love.physics.newBody(world, x, y, 'dynamic')
  local armShape = love.physics.newRectangleShape(20, 5)
  local armFix = love.physics.newFixture(arm, armShape)
  love.physics.newRevoluteJoint(shoulder, arm, x, y)

  local forearm = love.physics.newBody(world, x + 20, y, 'dynamic')
  forearm:setMass(100)
  local forearmShape = love.physics.newRectangleShape(20, 5)
  local forearmFix = love.physics.newFixture(forearm, forearmShape)
  local elbow = love.physics.newRevoluteJoint(arm, forearm, x+20, y, true)
  elbow:setLimits(0, math.pi/2)

  local hand = love.physics.newBody(world, x+40, y, 'dynamic')
  local handFix = love.physics.newFixture(hand, love.physics.newRectangleShape(5,5))
  love.physics.newWeldJoint(hand, forearm, x+40, y)
  table.insert(segments, armFix)
  table.insert(segments, forearmFix)
  table.insert(segments, handFix)
  return hand, segments
end

function Shooter.NewShooter(x, y, joystick, world)
  local self = setmetatable({}, Shooter)

  self.position = {
    ['x'] = x, ['y'] = y,
    ['handX'] = 0, ['handY'] = 0
  }
  self.hand, self.arm = Shooter.PrepareArm(x, y, world)
  self.joystick = joystick

  return self
end

function Shooter:updateHandLocation(x, y)
  if math.abs(x) < 0.1 and math.abs(y) < 0.1 then
    self:setType('static')
    return
  end
  self:setType('dynamic')
  self.hand:setX(self.position.x + x*60)
  self.hand:setY(self.position.y + y*60)
end

function Shooter:setType(bodyType)
  self.hand:setType(bodyType)
  for i, segment in ipairs(self.arm) do
    body = segment:getBody()
    body:setType(bodyType)
  end
end

function Shooter:update()
  xAxisLeft = self.joystick:getGamepadAxis('leftx')
  yAxisLeft = self.joystick:getGamepadAxis('lefty')
  self:updateHandLocation(xAxisLeft, yAxisLeft)
end

function Shooter:draw()
  for i, segment in ipairs(self.arm) do
    local body = segment:getBody()
    local shape = segment:getShape()
    love.graphics.setColor(75*i, 0, 0)
    love.graphics.polygon('line', body:getWorldPoints(shape:getPoints()))
    love.graphics.reset()
  end
end
