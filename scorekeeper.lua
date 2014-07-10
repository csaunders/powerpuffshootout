Scorekeeper = {}
Scorekeeper.__index = Scorekeeper

ScorekeeperGlobalScore = nil

function Scorekeeper.GetInstance()
  if ScorekeeperGlobalScore == nil then
    ScorekeeperGlobalScore = Scorekeeper.NewScorekeeper()
  end
  return ScorekeeperGlobalScore
end

function Scorekeeper.NewScorekeeper()
  local self = setmetatable({}, Scorekeeper)
  self.scores = {}
  return self
end

function Scorekeeper:addScoreable(name, attributes)
  self.scores[name] = attributes
  self.scores[name].value = 0
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
