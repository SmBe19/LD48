extends Camera2D

var camoffset = Vector2(0, 250)
var shake_duration = 0.0
var rng = RandomNumberGenerator.new()

func _ready():
	var rs = $"/root".size
	var orig = Vector2(540, 960)
	var prop = rs / orig
	var height = orig.y
	if prop.y > prop.x:
		height = rs.y / prop.x
	camoffset = Vector2(0, height * 0.25)

func _process(delta):
	position = $"../Player".position + camoffset
	if shake_duration > 0:
		position += Vector2(rng.randf(), rng.randf()).normalized() * shake_duration * shake_duration * 10
		shake_duration -= delta

func shake(strength):
	shake_duration = 1.0 * strength
