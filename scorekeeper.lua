Scorekeeper = {GlobalScore = nil}
Scorekeeper.__index = Scorekeeper

function Scorekeeper.GetInstance()
  if Scorekeeper.GlobalScore == nil then
    Scorekeeper.GlobalScore = Scorekeeper.NewScorekeeper()
  end
  return Scorekeeper.GlobalScore
end

function Scorekeeper.NewScorekeeper()
  local self = setmetatable({['scores'] = {}}, Scorekeeper)
  return self
end

function Scorekeeper:addScoreable(name, attributes)
  self.scores[name] = attributes
  self.scores[name]['value'] = 0
end

function Scorekeeper:increment(name)
  attributes = self.scores[name]
  if attributes ~= nil then
    self.scores[name].value = attributes.value + 1
  end
end

function Scorekeeper:getScore(name)
  attributes = self.scores[name]
  if attributes ~= nil then
    return attributes.value
  else
    return -1
  end
end

function Scorekeeper:reset()
  for name, drawdata in pairs(self.scores) do
    drawdata.value = 0
  end
end
