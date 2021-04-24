extends Node2D

const obstacle = preload("res://scn/Obstacle.tscn")
const powerup = preload("res://scn/PowerUp.tscn")
var rng = RandomNumberGenerator.new()

var last_height = -800
var precreate = 1000
var obst_per_height = 0.1
var time_per_height = 0.06
var supertime_per_height = 0.01
var rect_per_height = 0.03
var dang_prob = 0.15
var bouncy_prob = 0.2
var xrand = 2000
var rotrand = 0.1
var create_every = 200
var headroom = 1000

func clean_children(ppos):
	for child in get_children():
		if child.position.y < ppos.y - headroom:
			child.queue_free()

func create_obstacles(ppos, count):
	for i in count:
		var new_obstacle = obstacle.instance()
		new_obstacle.rotation = rng.randf_range(-rotrand, rotrand)
		new_obstacle.position.x = rng.randf_range(-xrand, xrand) + ppos.x
		new_obstacle.position.y = rng.randf_range(last_height, ppos.y) + precreate
		new_obstacle.width = rng.randf_range(1, 4)
		new_obstacle.dangerous = rng.randf() < dang_prob
		new_obstacle.bouncy = rng.randf() < bouncy_prob
		add_child(new_obstacle)

func create_powerups(ppos, group, color, count):
	print(group, ": ", count)
	for i in count:
		var new_up = powerup.instance()
		new_up.add_to_group(group)
		new_up.color = color
		new_up.position.x = rng.randf_range(-xrand, xrand) + ppos.x
		new_up.position.y = rng.randf_range(last_height, ppos.y) + precreate
		add_child(new_up)

func place_obstacles():
	var ppos = $"../Player".position
	clean_children(ppos)
	create_obstacles(ppos, (ppos.y - last_height) * obst_per_height)
	create_powerups(ppos, "rectup", Color.lightgreen, int((ppos.y - last_height) * rect_per_height))
	create_powerups(ppos, "timeup", Color.yellow, int((ppos.y - last_height) * time_per_height))
	create_powerups(ppos, "supertimeup", Color.darkmagenta, int((ppos.y - last_height) * supertime_per_height * max(1, sqrt(ppos.y / 1000)) * rng.randf()))
	last_height = ppos.y

func _process(_delta):
	if $"../Player".position.y > last_height + create_every:
		place_obstacles()
	if mouse_down:
		place_mouse_rect()

var mouse_down = false
var mouse_start = Vector2.ZERO
var mouse_rect = null

func get_mouse_pos():
	var gmp = $"/root/Root/Score".get_global_mouse_position()
	var corrected = gmp - get_canvas_transform().origin
	return corrected

func place_mouse_rect():
	var pos = get_mouse_pos()
	var dist = mouse_start.distance_to(pos)
	var wanted_size = dist + 30
	mouse_rect.width = wanted_size / 30.0
	mouse_rect.position = (mouse_start + pos) / 2
	var angle = mouse_start.angle_to_point(pos)
	mouse_rect.rotation = angle

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			if $"../Player".remaining_rectangles > 0:
				mouse_down = true
				mouse_start = get_mouse_pos()
				mouse_rect = obstacle.instance()
				mouse_rect.color = Color.lightgoldenrod
				mouse_rect.get_node("Collision").disabled = true
				place_mouse_rect()
				add_child(mouse_rect)
		elif event.button_index == BUTTON_LEFT and not event.pressed:
			if mouse_down:
				mouse_down = false
				mouse_rect.color = Color.aqua
				mouse_rect.get_node("Collision").disabled = false
				mouse_rect.update()
				mouse_rect = null
				$"../Player".remaining_rectangles -= 1

func _ready():
	rng.randomize()
	place_obstacles()
