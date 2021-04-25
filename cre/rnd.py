import random
import json

rects = []
powerups = []

for i in range(random.randrange(3, 20)):
    rects.append({
        'x': random.randrange(700),
        'y': random.randrange(700),
        'w': random.uniform(1, 10),
        'r': random.uniform(-0.5, 0.5),
        'd': random.random() < 0.1,
        'b': random.random() < 0.1,
    })

def gen_powerups(t, mi, ma):
    for i in range(random.randrange(mi, ma)):
        powerups.append({
            'x': random.randrange(700),
            'y': random.randrange(700),
            't': t,
        })

gen_powerups('timeup', 5, 10)
gen_powerups('rectup', 5, 10)
gen_powerups('supertimeup', 0, 2)

lvl = {
    'rects': rects,
    'powerups': powerups,
}

with open('lvl/lvl1.json', 'w') as f:
    json.dump(lvl, f, indent=2)
