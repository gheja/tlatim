extends Control

func _process(_delta):
	$EnergyBar.value = GameState.energy
	$TimeLeftLabel.bbcode_text = " " + str(GameState.time)
