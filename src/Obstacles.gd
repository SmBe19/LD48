extends Node2D

const obstacle = preload("res://scn/Obstacle.tscn")
const powerup = preload("res://scn/PowerUp.tscn")
var rng = RandomNumberGenerator.new()

var last_height_gen = 200
var clean_children_timer = 0
var mouse_down = false
var mouse_start = Vector2.ZERO
var mouse_rect = null

func clean_children(delta):
	clean_children_timer -= delta
	if clean_children_timer > 0:
		return
	clean_children_timer = 5
	var ppos = $"../Player".position
	for child in get_children():
		if child.position.y < ppos.y - Globals.lvl_headroom:
			child.queue_free()

func add_lvl(lvl, xoff, yoff, mirrored):
	var file = File.new()
	file.open("res://lvl/lvl" + str(lvl) + ".json", File.READ)
	var json = parse_json(file.get_as_text())
	if json == null:
		print('Could not load level ', lvl)
		return
	for rect in json['rects']:
		var new_rect = obstacle.instance()
		if mirrored:
			new_rect.rotation = -rect['r']
			new_rect.position = Vector2(Globals.lvl_box.x - rect['x'] + xoff, rect['y'] + yoff)
		else:
			new_rect.rotation = rect['r']
			new_rect.position = Vector2(rect['x'] + xoff, rect['y'] + yoff)
		new_rect.width = rect['w']
		new_rect.dangerous = rect['d']
		new_rect.bouncy = rect['b']
		add_child(new_rect)
	for pup in json['powerups']:
		var new_up = powerup.instance()
		new_up.add_to_group(pup['t'])
		if mirrored:
			new_up.position = Vector2(Globals.lvl_box.x - pup['x'] + xoff, pup['y'] + yoff)
		else:
			new_up.position = Vector2(pup['x'] + xoff, pup['y'] + yoff)
		add_child(new_up)

func place_obstacles():
	var ppos = $"../Player".position
	while last_height_gen <= ppos.y + Globals.lvl_precreate * Globals.lvl_box.y:
		var playerx = round(ppos.x / Globals.lvl_box.x) * Globals.lvl_box.x
		for i in range(-Globals.lvl_gen_x, Globals.lvl_gen_x+1):
			var lvl = rng.randi_range(1, Globals.lvl_count)
			var mirrored = rng.randf() < 0.5
			if Globals.is_editor:
				lvl = Globals.editor_lvl
				mirrored = Input.is_action_pressed("ui_select")
			add_lvl(lvl, playerx + i * Globals.lvl_box.y, last_height_gen, mirrored)
		last_height_gen += Globals.lvl_box.y

func _process(delta):
	place_obstacles()
	clean_children(delta)
	if mouse_down:
		place_mouse_rect()

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
