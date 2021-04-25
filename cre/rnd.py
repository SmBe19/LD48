import random
import json

def gen_one(idx):
    rects = []
    powerups = []

    for i in range(random.randrange(3, 15)):
        rects.append({
            'x': random.randrange(700),
            'y': random.randrange(700),
            'w': random.uniform(1, 4),
            'r': random.uniform(-0.4, 0.4),
            'd': random.random() < 0.15,
            'b': random.random() < 0.2,
        })

    def gen_powerups(t, mi, ma):
        for i in range(random.randrange(mi, ma)):
            powerups.append({
                'x': random.randrange(700),
                'y': random.randrange(700),
                't': t,
            })

    gen_powerups('timeup', 2, 7)
    gen_powerups('rectup', 2, 7)
    gen_powerups('supertimeup', 0, 2)

    lvl = {
        'rects': rects,
        'powerups': powerups,
    }

    with open('lvl/lvl{}.json'.format(idx), 'w') as f:
        json.dump(lvl, f, indent=2)

for i in range(21, 41):
    gen_one(i)
