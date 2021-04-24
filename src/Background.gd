extends Node2D

var xcount = 100
var ycount = 100
var distance = 100

func _draw():
	var pos = $"../Player".position
	var startx = (int(pos.x) / distance) * distance
	var starty = (int(pos.y) / distance) * distance
	for x in xcount:
		var xx = startx - xcount / 2 * distance + x * distance
		draw_line(Vector2(xx, starty - 10000), Vector2(xx, starty + 10000), Color(0.55, 0.5, 0.5), 2, true)
	for y in ycount:
		var yy = starty - ycount / 2 * distance + y * distance
		draw_line(Vector2(startx - 10000, yy), Vector2(startx + 10000, yy), Color(0.5, 0.5, 0.55), 2, true)

var timer = 0

func _process(delta):
	timer -= delta
	if timer < 0:
		timer = 10
		update()
