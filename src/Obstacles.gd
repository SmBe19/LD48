extends Node2D

const obstacle = preload("res://scn/Obstacle.tscn")
var rng = RandomNumberGenerator.new()

var last_height = -1800
var precreate = 2000
var obst_per_height = 0.1
var xrand = 2000
var rotrand = 0.1
var create_every = 200
var headroom = 500

func place_obstacles():
	var ppos = $"../Player".position
	var count = (ppos.y - last_height) * obst_per_height
	for child in get_children():
		if child.position.y < ppos.y - headroom:
			child.queue_free()
	for i in count:
		var new_obstacle = obstacle.instance()
		new_obstacle.rotation = rng.randf_range(-rotrand, rotrand)
		new_obstacle.position.x = rng.randf_range(-xrand, xrand) + ppos.x
		new_obstacle.position.y = rng.randf_range(last_height, ppos.y) + precreate
		new_obstacle.width = rng.randf_range(1, 4)
		new_obstacle.dangerous = rng.randf() < 0.1
		add_child(new_obstacle)
	last_height = ppos.y

func _process(_delta):
	if $"../Player".position.y > last_height + create_every:
		place_obstacles()
	if mouse_down:
		place_mouse_rect()

var mouse_down = false
var mouse_start = Vector2.ZERO
var mouse_rect = null

func place_mouse_rect():
	var pos = get_global_mouse_position()
	var dist = mouse_start.distance_to(pos)
	var wanted_size = dist + 30
	mouse_rect.width = wanted_size / 30.0
	mouse_rect.position = (mouse_start + pos) / 2
	var angle = mouse_start.angle_to_point(pos)
	mouse_rect.rotation = angle

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			mouse_down = true
			mouse_start = get_global_mouse_position()
			mouse_rect = obstacle.instance()
			mouse_rect.color = Color.lightgoldenrod
			mouse_rect.get_node("Collision").disabled = true
			place_mouse_rect()
			add_child(mouse_rect)
		elif event.button_index == BUTTON_LEFT and not event.pressed:
			mouse_down = false
			mouse_rect.color = Color.aqua
			mouse_rect.get_node("Collision").disabled = false
			mouse_rect.update()
			mouse_rect = null

func _ready():
	rng.randomize()
	place_obstacles()
