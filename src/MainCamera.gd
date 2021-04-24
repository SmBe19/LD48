extends Camera2D

const camoffset = Vector2(0, 250)

func _process(_delta):
	position = $"../Player".position + camoffset
