import random
import json

rects = []
powerups = []

for i in range(random.randrange(3, 15)):
    rects.append({
        'x': random.randrange(700),
        'y': random.randrange(700),
        'w': random.uniform(1, 10),
        'r': random.uniform(-0.4, 0.4),
        'd': random.random() < 0.2,
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

with open('lvl/lvl1.json', 'w') as f:
    json.dump(lvl, f, indent=2)
