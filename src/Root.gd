extends ViewportContainer

func _ready():
	if OS.get_name() == "Android" or OS.get_name() == "HTML5":
		material = null;
	if Globals.is_editor:
		ProjectSettings.set("physics/2d/default_gravity", 0)

var timer = 1

func _process(delta):
	if Globals.is_editor:
		timer -= delta
		if timer < 0:
			restart()

func restart():
	$Viewport.get_child(0).queue_free()
	$Viewport.add_child(preload("res://scn/Game.tscn").instance())

var audio_pos = 0

func _on_CheckBox_toggled(button_pressed):
	if button_pressed:
		$"../Music".play()
		$"../Music".seek(audio_pos)
	else:
		audio_pos = $"../Music".get_playback_position()
		$"../Music".stop()
