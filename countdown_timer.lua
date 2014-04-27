require('countdown_definitions')
CountdownTimer = {}
CountdownTimer.__index = CountdownTimer
CountdownTimer.Events = {
  ['boom'] = love.audio.newSource('Assets/Audio/boom_quiet.wav', 'static'),
  ['draw'] = love.audio.newSource('Assets/Audio/draw.wav', 'static'),
}

function CountdownTimer.ThreeTwoOneDraw()
  return CountdownTimer.NewCountdownTimer(CountdownDefinitions.ThreeTwoOneDraw)
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
  self.frameDuration = math.random(3, 5)*10
  self.step = math.random(3, 6)*10
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
    self.position = self.position + 1
    self.currentDuration = 0
    self:handleEvent()
  end
end

function CountdownTimer:currentFrame()
  return self.timings[self.position]
end

function CountdownTimer:checkCountingDown()
  if self.position > table.getn(self.timings) then
    self.countingDown = false
  end
  return self.countingDown
end

function CountdownTimer:handleEvent()
  frame = self:currentFrame()
  if not (frame and frame.event) then return end
  action = CountdownTimer.Events[frame.event]
  if action then
    if action:isPlaying() then
      action:seek(0)
    else
      action:play()
    end
  else
    LogUnhandledEvent('CountdownTimer', frame.event)
  end
end

function CountdownTimer:draw()
  if not self.countingDown then return end
  frame = self:currentFrame()

  if frame.drawPrevious then
    self:drawAllToFrame()
  else
    self:drawFrame(frame)
  end
end

function CountdownTimer:drawAllToFrame()
  for i=1, self.position do
    frame = self.timings[i]
    self:drawFrame(frame)
  end
end

function CountdownTimer:drawFrame(frame)
 love.graphics.setColor(frame.color)
 love.graphics.draw(frame.image)
 love.graphics.reset()
end
