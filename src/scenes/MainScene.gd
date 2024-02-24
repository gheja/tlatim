extends Node

func _ready():
	# no 120 hz and 144 hz, sorry (some timings rely on a fixed 60 fps)
	Engine.set_target_fps(60)
	VisualServer.set_default_clear_color(Color(0, 0, 0))
