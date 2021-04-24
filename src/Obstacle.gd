extends Node2D

var size = 15
var width = 1 setget set_width
var color = Color.lightgreen
var dangerous = false

func set_width(w):
	width = w
	$Collision.scale.x = width
	update()

func get_width():
	return width

func _ready():
	set_width(width)
	if dangerous:
		add_to_group("dangerous")
		color = Color.lightcoral

func _draw():
	draw_rect(Rect2(-size*width, -size, width*size*2, size*2), color, false, Globals.line_width, true)
