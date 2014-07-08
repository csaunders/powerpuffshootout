require "../scorekeeper"

function test_get_instance()
  assert_equal(nil, Scorekeeper.GlobalScore)
  instance = Scorekeeper.GetInstance()
  assert_equal(instance, Scorekeeper.GlobalScore)
end

function test_initialize_scorekeeper()
  scorekeeper = Scorekeeper.NewScorekeeper()
  assert_equal(0, #scorekeeper.scores)
end

function test_adding_a_scoreable()
  scorekeeper = Scorekeeper.NewScorekeeper()
  scorekeeper.addScoreable('player1', {['x'] = 0, ['y'] = 0})
  scorekeeper.addScoreable('player2', {['x'] = 0, ['y'] = 0})
  assert_equal(2, #scorekeeper.scores)
end

function test_incrementing_a_score()
  scorekeeper = Scorekeeper.NewScorekeeper()
  scorekeeper.addScoreable('player1', {})
  scorekeeper.increment('player1')
  assert_equal(1, scorekeeper.getScore('player1'))
end

function test_incrementing_a_score_for_a_nonexistent_scorable()
  scorekeeper = Scorekeeper.NewScorekeeper()
  scorekeeper.increment('something')
  assert_equal(-1, scorekeeper.getScore('something'))
  assert_equal(1, 2)
end
