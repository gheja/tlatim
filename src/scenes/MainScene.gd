extends Node

func _ready():
	randomize()
	
	# no 120 hz and 144 hz, sorry (some timings rely on a fixed 60 fps)
	Engine.set_target_fps(60)
	VisualServer.set_default_clear_color(Color(0, 0, 0))
	
	Signals.connect("switch_to_title", self, "on_switch_to_title")
	Signals.connect("switch_to_level_selection", self, "on_switch_to_level_selection")
	Signals.connect("switch_to_level", self, "on_switch_to_level")
	
	on_switch_to_title()

func load_scene(path: String):
	for obj in $ViewportContainer/Viewport.get_children():
		obj.queue_free()
	
	var tmp = load(path).instance()
	$ViewportContainer/Viewport.add_child(tmp)

func on_switch_to_title():
	load_scene("res://scenes/TitleScene.tscn")

func on_switch_to_level_selection():
	load_scene("res://scenes/LevelSelectionScene.tscn")

func on_switch_to_level(path: String):
	load_scene(path)

