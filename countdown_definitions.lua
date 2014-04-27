    ['three'] = love.graphics.newImage(),
    ['two'] = love.graphics.newImage('Assets/Art/2.png'),
    ['one'] = love.graphics.newImage('Assets/Art/1.png'),
    ['draw'] = love.graphics.newImage('Assets/Art/draw.png'),
CountdownDefinitions = {}
CountdownDefinitions.ThreeTwoOneDraw = {
  ['timings'] = {
    {
      ['image'] = 'Assets/Art/3.png',
      ['color'] = {255, 0, 0},,
      ['event'] = 'boom',
    },
    {
      ['image'] = 'Assets/Art/2.png',
      ['color'] = {0, 255, 0},
      ['event'] = 'boom',
    },
    {
      ['image'] = 'Assets/Art/1.png',
      ['color'] = {0, 0, 255},
      ['event'] = 'boom',
    },
    {
      ['image'] = 'Assets/Art/draw.png',
      ['color'] = {255, 255, 255}
      ['event'] = 'draw'
    },
  }
}
