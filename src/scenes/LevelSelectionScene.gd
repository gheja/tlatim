extends Control

var level_index = 0

var level_list = [
	[ "Tutorial 1", "", "res://scenes/LevelTutorial1.tscn" ],
	[ "Tutorial 2", "", "res://scenes/LevelTutorial2.tscn" ],
	[ "Level 1", "", "res://scenes/Level1.tscn" ],
	[ "Level 2", "", "res://scenes/Level1.tscn" ],
	[ "Level 3", "", "res://scenes/Level1.tscn" ],
]

func _ready():
	var s
	var t
	
	$Control/ArrowSprite.rect_position.y = 12
	
	s = ""
	t = "[right]"
	
	for level in level_list:
		s += level[0] + "\n"
		t += "-\n"
	
	t += "[/right]"
	
	$Control/LevelListWindow/LevelNameLabel.bbcode_text = s
	$Control/LevelListWindow/PointsLabel.bbcode_text = t
	
	update_level_window()

func update_level_window():
	$Control/LevelListWindow.rect_position.y = 12 - level_index * 8

func back_to_title():
	Signals.emit_signal("switch_to_title")

func start_level():
	Signals.emit_signal("switch_to_level", level_list[level_index][2])

func _unhandled_input(event):
	if event.is_action_pressed("ui_down"):
		level_index += 1
	elif event.is_action_pressed("ui_up"):
		level_index -= 1
	elif event.is_action_pressed("action_first"):
		back_to_title()
	elif event.is_action_pressed("action_second"):
		start_level()
	
	if level_index < 0:
		level_index = 0
	
	if level_index >= level_list.size():
		level_index = level_list.size() - 1
	
	update_level_window()