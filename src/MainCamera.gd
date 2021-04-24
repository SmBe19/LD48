extends Camera2D

const camoffset = Vector2(0, 250)
var shake_duration = 0.0
var rng = RandomNumberGenerator.new()

func _process(delta):
	position = $"../Player".position + camoffset
	if shake_duration > 0:
		position += Vector2(rng.randf(), rng.randf()).normalized() * shake_duration * shake_duration * 10
		shake_duration -= delta

func shake(strength):
	shake_duration = 1.0 * strength
