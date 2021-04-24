extends RigidBody2D

var radius = 30
var lines = 4
var color = Color.lightsalmon setget set_color
var max_angle = TAU setget set_max_angle

func set_color(c):
	color = c
	update()

func set_max_angle(a):
	max_angle = a
	update()

func _draw():
	var parts = 64
	var last = Vector2(1, 0)
	for i in parts:
		var angle = TAU*i/float(parts-1)
		if angle > max_angle:
			continue
		var next = Vector2(cos(angle), sin(angle))
		draw_line(last * radius, next * radius, color, Globals.line_width, true)
		last = next
	for i in lines:
		var angle = TAU*i/float(lines)
		if angle >= max_angle:
			continue
		draw_line(Vector2.ZERO, Vector2.ZERO + radius * Vector2(cos(angle), sin(angle)), color, Globals.line_width, true)

var dead = false

func die():
	if dead:
		return
	set_deferred("mode", RigidBody2D.MODE_STATIC)
	$IDieTween.interpolate_property(self, "color", color, Color(color.r, color.g, color.b, 0), 2)
	$IDieTween.interpolate_property(self, "max_angle", TAU, 0, 2)
	$IDieTween.start()
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = 3
	timer.connect("timeout", self, "restart_game")
	timer.start()
	dead = true

func restart_game():
	var _res = get_tree().reload_current_scene()

var next_shot = 0
var last_pos = Vector2.ZERO
var last_velo = Vector2.ZERO
var same_shot = 0

func _process(delta):
	if dead:
		return
	next_shot -= delta
	if next_shot < 0:
		next_shot = 0.5
		if position.distance_squared_to(last_pos) < 5:
			same_shot += 1
			if same_shot > 3:
				print("Player died: did not move")
				die()
		else:
			same_shot = 0
		last_pos = position
	if linear_velocity.distance_squared_to(last_velo) > 100000:
		print("Player died: too fast")
		die()
	last_velo = linear_velocity


func _on_AmIDie_body_entered(body):
	if body.is_in_group("dangerous"):
		print("Player died: dangerous rectangle")
		die()
