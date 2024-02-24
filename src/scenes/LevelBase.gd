extends Node2D

export var time_max = 30
export var wind = 0.33

onready var player_obj = $PlayerCharacter
onready var camera_obj = $CameraContainer
onready var dust_objects = $CameraContainer/DustObjects

func init_dust():
	var tmp
	
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
		
		AudioManager.play_sfx(1)
		
	elif n == 2:
		if GameState.energy < 20:
			return
		
		GameState.energy -= 20
		
		tmp = preload("res://scenes/LargeSnowflakeObject.tscn").instance()
		$LevelObjects.add_child(tmp)
		tmp.move_to_player()
		
		AudioManager.play_sfx(1)

func check_win_conditions():
	for obj in get_tree().get_nodes_in_group("ground_objects"):
		if not obj.is_complete():
			return false
	
	show_popup_text("Level complete!")
	return true

func show_popup_text(s):
	var tmp = preload("res://scenes/PopupTextOverlay.tscn").instance()
	tmp.set_text(s)
	$CameraContainer.add_child(tmp)

func check_lose_conditions():
	if GameState.time == 0:
		show_popup_text("Time is up!")
		return true
	
	return false

func check_win_lose_conditions():
	if check_win_conditions():
		GameState.state = GameState.GAME_STATE_WON
		Signals.emit_signal("game_won")
		if get_tree().get_nodes_in_group("persons").size() > 0:
			# let them jump around
			$ScoringStartTimer.start()
		else:
			$ScoringStartShortTimer.start()
		return
	
	if check_lose_conditions():
		GameState.state = GameState.GAME_STATE_LOST
		Signals.emit_signal("game_lost")
		$ScoringStartShortTimer.start()
		return

func on_object_completed():
# 	check_win_lose_conditions()
	pass

func reset_game():
	GameState.time_max = time_max
	GameState.wind = wind
	GameState.energy = GameState.energy_max
	GameState.time = GameState.time_max

func update_camera():
#	while camera_obj.position.x - player_obj.position.x > 24:
#		camera_obj.position.x -= 1
#
#	while camera_obj.position.x - player_obj.position.x < - 26:
#		camera_obj.position.x += 1
	
	while camera_obj.position.x > player_obj.position.x - 18:
		camera_obj.position.x -= 1
	
	while camera_obj.position.x < player_obj.position.x - 68:
		camera_obj.position.x += 1

func _ready():
	$HorizontalBounds.hide()
	$BackgroundSprite.hide()
	Signals.connect("player_action_first", self, "on_player_action", [ 1 ])
	Signals.connect("player_action_second", self, "on_player_action", [ 2 ])
	Signals.connect("object_completed", self, "on_object_completed")
	init_dust()
	reset_game()

func _process(_delta):
	if GameState.state != GameState.GAME_STATE_PLAYING:
		return
	
	check_win_lose_conditions()

func _on_ScoringStartTimer_timeout():
	var tmp = preload("res://scenes/LevelScoringOverlay.tscn").instance()
	$CameraContainer.add_child(tmp)
