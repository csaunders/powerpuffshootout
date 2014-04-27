SpriteFrameDefinitions = {}
SpriteFrameDefinitions.Princess1 = {
  ['idle'] = {
    {
      ['image'] = 'Assets/Art/pixel anims/p2-idle-1.png',
      ['duration'] = 0.5,
    },
    {
      ['image'] = 'Assets/Art/pixel anims/p2-idle-2.png',
      ['duration'] = 0.2,
    },
    {
      ['image'] = 'Assets/Art/pixel anims/p2-idle-3.png',
      ['duration'] = 0.5,
    },
    {
      ['image'] = 'Assets/Art/pixel anims/p2-idle-4.png',
      ['duration'] = 0.2,
      ['next'] = 1,
    }
  },
['shooting'] = {
    {
      ['image'] = 'Assets/Art/pixel anims/p2-fire-1.png',
      ['duration'] = 0.3,
      ['xoffset'] = -16,
    },
    {
      ['image'] = 'Assets/Art/pixel anims/p2-fire-2.png',
      ['duration'] = 0.1,
      ['xoffset'] = -32,
      ['event'] = 'fire'
    },
    {
      ['image'] = 'Assets/Art/pixel anims/p2-fire-3.png',
      ['duration'] = 0.1,
      ['xoffset'] = -16,
    },
    {
      ['image'] = 'Assets/Art/pixel anims/p2-fire-4.png',
      ['duration'] = 0.4,
      ['xoffset'] = -16,
    }
  },
['dodging'] = {
    {
      ['image'] = 'Assets/Art/pixel anims/p2-dodge-1.png',
      ['duration'] = 0.10,
      ['event'] = 'dodge'
    },
    {
      ['image'] = 'Assets/Art/pixel anims/p2-dodge-2.png',
      ['duration'] = 0.1,
    },
    {
      ['image'] = 'Assets/Art/pixel anims/p2-dodge-3.png',
      ['duration'] = 0.2,
      ['event'] = 'dodgeDone',
    },
    {
      ['image'] = 'Assets/Art/pixel anims/p2-dodge-4.png',
      ['duration'] = 0.15,
    }
  },
  ['death'] = {
    {
      ['image'] = 'Assets/Art/pixel anims/p2-death-1.png',
      ['duration'] = 0.1,
    },
    {
      ['image'] = 'Assets/Art/pixel anims/p2-death-2.png',
      ['duration'] = 0.15,
    },
    {
      ['image'] = 'Assets/Art/pixel anims/p2-death-3.png',
      ['duration'] = 0.3,
    },
    {
      ['image'] = 'Assets/Art/pixel anims/p2-death-4.png',
      ['duration'] = 0.4,
    },
    {
      ['image'] = 'Assets/Art/pixel anims/p2-death-5.png',
      ['duration'] = 0.05,
      ['event'] = 'doneDeath',
    },
    {
      ['image'] = 'Assets/Art/pixel anims/p2-death-5.png',
      ['duration'] = 0.1,
      ['next'] = 6
    },
  },
  ['taunt'] = {
    {
      ['image'] = 'Assets/Art/pixel anims/p2-taunt-1.png',
      ['duration'] = 0.08,
    },
    {
      ['image'] = 'Assets/Art/pixel anims/p2-taunt-2.png',
      ['duration'] = 0.08,
    },
  }
}

SpriteFrameDefinitions.Princess2 = {
  ['idle'] = {
    {
      ['image'] = 'Assets/Art/pixel anims/Chemo_Idle1.png',
      ['duration'] = 0.3,
    },
    {
      ['image'] = 'Assets/Art/pixel anims/Chemo_Idle2.png',
      ['duration'] = 0.3,
      ['next'] = 1,
    },
  },
['shooting'] = {
    {
      ['image'] = 'Assets/Art/pixel anims/Chemo_Fire1.png',
      ['duration'] = 0.35,
      ['event'] = 'fire',
    },
    {
      ['image'] = 'Assets/Art/pixel anims/Chemo_Fire2.png',
      ['duration'] = 0.1,
    },
    {
      ['image'] = 'Assets/Art/pixel anims/Chemo_Fire3.png',
      ['duration'] = 0.45,
    },
  },
['dodging'] = {
    {
      ['image'] = 'Assets/Art/pixel anims/Chemo_Block.png',
      ['duration'] = 0.10,
      ['event'] = 'dodge'
    },
    {
      ['image'] = 'Assets/Art/pixel anims/Chemo_Block2.png',
      ['duration'] = 0.3,
      ['event'] = 'dodgeDone',
    },
    {
      ['image'] = 'Assets/Art/pixel anims/Chemo_Block.png',
      ['duration'] = 0.15,
    }
  },
['death'] = {
    {
      ['image'] = 'Assets/Art/pixel anims/Chemo_Death1.png',
      ['duration'] = 0.1,
    },
    {
      ['image'] = 'Assets/Art/pixel anims/Chemo_Death2.png',
      ['duration'] = 0.15,
    },
    {
      ['image'] = 'Assets/Art/pixel anims/Chemo_Death3.png',
      ['duration'] = 0.3,
    },
    {
      ['image'] = 'Assets/Art/pixel anims/Chemo_Death4.png',
      ['duration'] = 0.4,
    },
    {
      ['image'] = 'Assets/Art/pixel anims/Chemo_Death5.png',
      ['duration'] = 0.05,
      ['event'] = 'doneDeath',
    },
    {
      ['image'] = 'Assets/Art/pixel anims/Chemo_Death5.png',
      ['duration'] = 0.1,
      ['next'] = 6
    },
  },
['taunt'] = {
    {
      ['image'] = 'Assets/Art/pixel anims/Chemo_Taunt1.png',
      ['duration'] = 0.08,
    },
    {
      ['image'] = 'Assets/Art/pixel anims/Chemo_Taunt2.png',
      ['duration'] = 0.08,
    },
  }
}
