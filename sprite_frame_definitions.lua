SpriteFrameDefinitions = {}
SpriteFrameDefinitions.Princess1 = {
  'idle' = {
    {
      'image' = 'Assets/Art/pixel anims/p2-idle-1.png',
      'duration' = 0.5,
    },
    {
      'image' = 'Assets/Art/pixel anims/p2-idle-2.png',
      'duration' = 0.2,
    },
    {
      'image' = 'Assets/Art/pixel anims/p2-idle-3.png',
      'duration' = 0.5,
    },
    {
      'image' = 'Assets/Art/pixel anims/p2-idle-4.png',
      'duration' = 0.2,
      'next' = 1,
    }
  }
'shooting' = {
    {
      'image' = 'Assets/Art/pixel anims/p2-fire-1.png',
      'duration' = 0.3,
    },
    {
      'image' = 'Assets/Art/pixel anims/p2-fire-2.png',
      'duration' = 0.1,
      'event' = 'fire',
    },
    {
      'image' = 'Assets/Art/pixel anims/p2-fire-3.png',
      'duration' = 0.5,
    }
  }
'dodging' = {
    {
      'image' = 'Assets/Art/pixel anims/p2-dodge-1.png',
      'duration' = 0.15,
    },
    {
      'image' = 'Assets/Art/pixel anims/p2-dodge-2.png',
      'duration' = 0.3,
      'event' = 'dodge',
    },
    {
      'image' = 'Assets/Art/pixel anims/p2-dodge-3.png',
      'duration' = 0.15,
    }
  }
}