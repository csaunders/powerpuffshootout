CleanLoopableSong = {}
CleanLoopableSong.__index = CleanLoopableSong

function CleanLoopableSong.NewSong(start, loopPoint, finish, source)
  local self = setmetatable({}, CleanLoopableSong)

  self.start = start
  self.loopPoint = loopPoint
  self.finish = finish
  self.source = source
  return self
end

function CleanLoopableSong:play()
  if not playMusic then return end
  self.source:seek(self.start)
  self.source:play()
end

function CleanLoopableSong:stop()
  self.source:stop()
end

function CleanLoopableSong:update()
  position = self.source:tell()
  if position >= self.finish then
    self.source:seek(self.loopPoint)
  end
end
