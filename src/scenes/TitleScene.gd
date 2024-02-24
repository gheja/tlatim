extends Node2D

func _unhandled_input(event):
	if event.is_action_pressed("action_first") or event.is_action_pressed("action_second"):
		Signals.emit_signal("switch_to_level_selection")
