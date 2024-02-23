extends Node2D

func init_dust():
	var tmp
	var dust_objects = $DustObjects
	
	for _i in range(20):
		tmp = preload("res://scenes/DustObject.tscn").instance()
		dust_objects.add_child(tmp)

func on_player_action(n: int):
	var tmp
	
	if n == 1:
		if GameState.energy < 10:
			return
		
		GameState.energy -= 10
		tmp = preload("res://scenes/SmallSnowflakeObject.tscn").instance()
		$LevelObjects.add_child(tmp)
		tmp.move_to_player()
		
	elif n == 2:
		if GameState.energy < 20:
			return
		
		GameState.energy -= 20
		
		tmp = preload("res://scenes/LargeSnowflakeObject.tscn").instance()
		$LevelObjects.add_child(tmp)
		tmp.move_to_player()

func check_win_conditions():
	for obj in get_tree().get_nodes_in_group("ground_objects"):
		if not obj.is_complete():
			return false
	
	return true

func check_win_lose_conditions():
	if check_win_conditions():
		GameState.state = GameState.GAME_STATE_WON
		Signals.emit_signal("game_won")

func on_object_completed():
	check_win_lose_conditions()

func _ready():
	Signals.connect("player_action_first", self, "on_player_action", [ 1 ])
	Signals.connect("player_action_second", self, "on_player_action", [ 2 ])
	Signals.connect("object_completed", self, "on_object_completed")
	init_dust()
