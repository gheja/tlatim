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
		
	elif n == 2:
		if GameState.energy < 20:
			return
		
		GameState.energy -= 20
		
		tmp = preload("res://scenes/LargeSnowflakeObject.tscn").instance()
		$LevelObjects.add_child(tmp)

func _ready():
	Signals.connect("player_action_first", self, "on_player_action", [ 1 ])
	Signals.connect("player_action_second", self, "on_player_action", [ 2 ])
	init_dust()
