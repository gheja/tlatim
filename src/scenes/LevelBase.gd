extends Node2D

export var level_key = "unknown"
export var time_max = 30
export var energy_max = 100
export var wind = 0.33
export(Array, float) var wind_changes = [ ]

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
	
	if GameState.energy == 0 and get_tree().get_nodes_in_group("small_snowflakes").size() == 0 and get_tree().get_nodes_in_group("large_snowflakes").size() == 0:
		show_popup_text("Out of energy!")
		return true
	
	if GameState.oops_happened:
		show_popup_text("Oops...")
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
		
		AudioManager.play_sfx(5)
		return
	
	if check_lose_conditions():
		GameState.state = GameState.GAME_STATE_LOST
		Signals.emit_signal("game_lost")
		# $ScoringStartShortTimer.start()
		$ReturnToLevelSelectorTimer.start();
		return

func on_object_completed():
# 	check_win_lose_conditions()
	pass

func reset_game():
	if level_key == "unknown":
		push_error("Level key is unknown!")
	
	GameState.time_max = time_max
	GameState.wind = wind
	GameState.energy = GameState.energy_max
	GameState.time = GameState.time_max
	GameState.current_level_key = level_key
	GameState.oops_happened = false

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

func randomize_background():
	randomize()
	$BackgroundSprite2.position.x += randi() % 300 - 150
	$BackgroundSprite2.flip_h = (randi() % 2 == 1)

func _ready():
	randomize_background()
	
	$HorizontalBounds.hide()
	$BackgroundSprite.hide()
	Lib.silence(Signals.connect("player_action_left", self, "on_player_action", [ 1 ]))
	Lib.silence(Signals.connect("player_action_right", self, "on_player_action", [ 2 ]))
	Lib.silence(Signals.connect("object_completed", self, "on_object_completed"))
	Lib.silence(Signals.connect("time_changed", self, "on_time_changed"))
	Lib.silence(Signals.connect("oops", self, "on_oops"))
	init_dust()
	reset_game()
	
	AudioManager.play_music(7)

func _process(_delta):
	if GameState.state != GameState.GAME_STATE_PLAYING:
		return
	
	check_win_lose_conditions()

func _on_ScoringStartTimer_timeout():
	var tmp = preload("res://scenes/LevelScoringOverlay.tscn").instance()
	$CameraContainer.add_child(tmp)
	tmp.start(GameState.time, GameState.energy, get_tree().get_nodes_in_group("persons").size())

func _on_ReturnToLevelSelectorTimer_timeout():
	Signals.emit_signal("switch_to_level_selection")

func on_time_changed():
	for i in range(wind_changes.size() / 2):
		if int(GameState.time) == int(wind_changes[i * 2]):
			GameState.wind = wind_changes[i * 2 + 1]

func on_oops():
	GameState.oops_happened = true
