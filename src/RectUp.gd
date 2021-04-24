extends StaticBody2D

var color

func _draw():
	draw_circle(Vector2.ZERO, 10, color)
