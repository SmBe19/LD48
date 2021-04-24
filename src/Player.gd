extends RigidBody2D

var circle_parts = 64
var radius = 30
var lines = 4
var color = Color.lightblue setget set_color
var time_color = Color.yellow setget set_time_color
var rect_color = Color.lightgreen setget set_rect_color
var max_angle = TAU setget set_max_angle
var remaining_time = Globals.max_time
var display_remaining_time = Globals.max_time setget set_display_remaining_time
var remaining_rectangles = Globals.max_rectangles setget set_remaining_rectangles

func set_color(c):
	color = c
	update()

func set_max_angle(a):
	max_angle = a
	update()

func set_time_color(c):
	time_color = c
	update()

func set_rect_color(c):
	rect_color = c
	update()

func set_display_remaining_time(t):
	display_remaining_time = t
	update()

func set_remaining_rectangles(r):
	remaining_rectangles = r
	update()

func drw_circle(r, c, ma):
	var last = Vector2(1, 0)
	for i in circle_parts:
		var angle = TAU*i/float(circle_parts-1)
		if angle > ma:
			continue
		var next = Vector2(cos(angle), sin(angle))
		draw_line(last * r, next * r, c, Globals.line_width, true)
		last = next

func drw_lines():
	for i in lines:
		var angle = TAU*i/float(lines)
		if angle >= max_angle:
			continue
		draw_line(Vector2.ZERO, Vector2.ZERO + radius * Vector2(cos(angle), sin(angle)), color, Globals.line_width, true)
	

func _draw():
	drw_lines()
	drw_circle(radius - 2*Globals.line_width, rect_color, remaining_rectangles / float(Globals.max_rectangles) * TAU)
	drw_circle(radius - 4*Globals.line_width, time_color, display_remaining_time / Globals.max_time * TAU)
	drw_circle(radius, color, max_angle)

var dead = false

func die():
	if dead:
		return
	self.time_color = Color.yellow
	dead = true
	set_deferred("mode", RigidBody2D.MODE_STATIC)
	
	$IDieTween.interpolate_property(self, "color", color, Color(color.r, color.g, color.b, 0), 2)
	$IDieTween.interpolate_property(self, "max_angle", TAU, 0, 2)
	$IDieTween.interpolate_property(self, "display_remaining_time", remaining_time, 0, 2)
	$IDieTween.interpolate_property(self, "remaining_rectangles", remaining_rectangles, 0, 2)
	$IDieTween.start()
	
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = 3
	timer.connect("timeout", self, "restart_game")
	timer.start()

func restart_game():
	var _res = get_tree().reload_current_scene()

var next_shot = 0
var last_pos = Vector2.ZERO
var last_velo = Vector2.ZERO
var same_shot = 0
var last_time_upd_time_color = 0
var last_time_upd_disp_time = 0

func time(delta):
	remaining_time -= delta
	if remaining_time < 4:
		if abs(remaining_time - last_time_upd_time_color) > 0.25:
			if time_color == Color.yellow:
				self.time_color = Color.red
			else:
				self.time_color = Color.yellow
			last_time_upd_time_color = remaining_time
	else:
		if time_color != Color.yellow:
			self.time_color = Color.yellow
	if abs(remaining_time - last_time_upd_disp_time) > 1:
		self.display_remaining_time = remaining_time
		last_time_upd_disp_time = remaining_time
	if remaining_time < 0:
		print("Player died: time ran out")
		die()

func not_move(delta):
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

func fast_shake(delta):
	var diff = linear_velocity.distance_squared_to(last_velo)
	if diff > 200000:
		$"../MainCamera".shake(1)
	elif diff > 100000:
		$"../MainCamera".shake(0.5)
	elif diff > 50000:
		$"../MainCamera".shake(0.25)
	last_velo = linear_velocity

func _process(delta):
	if dead:
		return
	time(delta)
	not_move(delta)
	fast_shake(delta)


func _on_AmIDie_body_entered(body):
	if body.is_in_group("dangerous"):
		print("Player died: dangerous rectangle")
		die()
	elif body.is_in_group("timeup"):
		remaining_time = min(Globals.max_time, remaining_time + 4)
		body.queue_free()
	elif body.is_in_group("rectup"):
		self.remaining_rectangles = min(Globals.max_rectangles, remaining_rectangles + 2)
		body.queue_free()
