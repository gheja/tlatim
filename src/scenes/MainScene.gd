extends Node

func _ready():
	randomize()
	
	# no 120 hz and 144 hz, sorry (some timings rely on a fixed 60 fps)
	Engine.set_target_fps(60)
	VisualServer.set_default_clear_color(Color(0, 0, 0))
	
	Signals.connect("switch_to_title", self, "on_switch_to_title")
	Signals.connect("switch_to_level_selection", self, "on_switch_to_level_selection")
	Signals.connect("switch_to_level", self, "on_switch_to_level")
	Signals.connect("do_the_actual_transition", self, "on_do_the_actual_transition")
	
	# on_switch_to_title()
	load_scene("res://scenes/TitleScene.tscn")

var next_scene_to_load = null

func load_scene(path: String):
	for obj in $ViewportContainer/Viewport/SceneContainer.get_children():
		obj.queue_free()
	
	var tmp = load(path).instance()
	$ViewportContainer/Viewport/SceneContainer.add_child(tmp)

func on_do_the_actual_transition():
	if not next_scene_to_load:
		return
	
	load_scene(next_scene_to_load)
	
	next_scene_to_load = null

func transition_start(path: String):
	if GameState.transition_active:
		return
	
	next_scene_to_load = path
	
	var tmp = preload("res://scenes/TransitionOverlay.tscn").instance()
	$ViewportContainer/Viewport.add_child(tmp)

func on_switch_to_title():
	transition_start("res://scenes/TitleScene.tscn")

func on_switch_to_level_selection():
	transition_start("res://scenes/LevelSelectionScene.tscn")

func on_switch_to_level(path: String):
	transition_start(path)

