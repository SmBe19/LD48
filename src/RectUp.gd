extends StaticBody2D

var color

func _draw():
	draw_circle(Vector2.ZERO, 10, color)

func _ready():
	if is_in_group('timeup'):
		color = Color.yellow
	elif is_in_group('rectup'):
		color = Color.lightgreen
	elif is_in_group('supertimeup'):
		color = Color.darkmagenta
