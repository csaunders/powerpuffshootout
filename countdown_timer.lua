require('countdown_definitions')
CountdownTimer = {}
CountdownTimer.__index = CountdownTimer
Countdown.Events = {
  ['boom'] = 'BOOM!',
  ['draw'] = 'Draw!!'
}

function CountdownTimer.ThreeTwoOneDraw()
  return CountdownTimer.NewCountdownTimer(Countdown)
end

function CountdownTimer.NewCountdownTimer(definition)
  local self = setmetatable({}, CountdownTimer)

  self.timings = SpriteFrame.InitializeFrames(definition['timings'])
  self:reset()

  return self
end

function CountdownTimer:reset()
  self.seed = os.clock()
  self.currentDuration = 0
  self.position = 1
  self.countingDown = true

  math.randomseed(self.seed)
  self.frameDuration = math.random(1, 3)*0.1
  self.step = math.random(1, 10)*10
end

function CountdownTimer:update(dt)
  if not self.countingDown then return end

  self:incrementCurrentDuration(dt)
  self:nextPosition()
  self:checkCountingDown()
end

function CountdownTimer:incrementCurrentDuration(dt)
  self.currentDuration = self.currentDuration + dt*self.step
end

function CountdownTimer:nextPosition()
  if self.currentDuration >= self.frameDuration then
    self.nextPosition = self.nextPosition + 1
    frame = self:currentFrame
    if frame and frame.event then
      self:handleEvent(frame.event)
    end
  end
end

function CountdownTimer:currentFrame()
  self.timings[self.position]
end

function CountdownTimer:checkCountingDown()
  if self.position > table.getn(self.timings) then
    self.countingDown = false
  end
end

function CountdownTimer:handleEvent(event)
  action = CountdownTimer.Events[event]
  if action then
    print(action)
  else
    LogUnhandledEvent('CountdownTimer', event)
  end
end

function CountdownTimer:draw()
  if not self.countingDown then return end

  for i = 1, i < self.position do
    timing = self.timings[i]
    love.graphics.setColor(timing.color)
    love.graphics.draw(timing.image)
    love.reset()
  end
end
