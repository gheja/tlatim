extends Control

func do_the_actual_transition():
	Signals.emit_signal("do_the_actual_transition")

func _ready():
	GameState.transition_active = true

func finished():
	GameState.transition_active = false
	self.queue_free()
