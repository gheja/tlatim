extends Node2D

const ACTION_REPEAT_INTERVAL = 15

onready var face_sprite = $Visuals/FaceSprite

var frame = 0
var last_action_first_frame = null
var last_action_second_frame = null
var bounds_obj: Sprite = null
var level_base_obj: Node2D = null

func do_action(n: int):
	if n == 1:
		Signals.emit_signal("player_action_first")
	elif n == 2:
		Signals.emit_signal("player_action_second")

func handle_direction_buttons():
	# slow it down a bit
	if frame % 2 == 0:
		return

	if Input.is_action_pressed("ui_left"):
		if self.position.x > bounds_obj.position.x - bounds_obj.scale.x / 2:
			self.position.x += -1
	elif Input.is_action_pressed("ui_right"):
		if self.position.x < bounds_obj.position.x + bounds_obj.scale.x / 2:
			self.position.x += 1

func handle_action_buttons():
	if Input.is_action_pressed("action_first"):
		if last_action_first_frame == null:
			last_action_first_frame = frame
		
		if (frame - last_action_first_frame) % ACTION_REPEAT_INTERVAL == 0:
			do_action(1)
	else:
		last_action_first_frame = null
	
	if Input.is_action_pressed("action_second"):
		if last_action_second_frame == null:
			last_action_second_frame = frame
		
		if (frame - last_action_second_frame) % ACTION_REPEAT_INTERVAL == 0:
			do_action(2)
	else:
		last_action_second_frame = null

func handle_face_animation():
	if GameState.state == GameState.GAME_STATE_WON:
		face_sprite.frame = 5
		return
	
	if GameState.state == GameState.GAME_STATE_LOST:
		face_sprite.frame = 6
		return
	
	# the second action is active
	if last_action_second_frame != null:
		face_sprite.frame = 4
		return
	
	var a = frame % 120
	
	if a < 110:
		if a % 30 == 0:
			face_sprite.frame = Lib.array_pick([0, 1, 2])
	elif a < 120:
		face_sprite.frame = 3

func increase_energy():
	# disabled
	return
	
	
	if frame % 3 != 0:
		return
	
	if GameState.energy < GameState.energy_max:
		GameState.energy += 1

func reduce_timer():
	if frame % 60 != 0:
		return
	
	if GameState.time <= 0:
		return
	
	GameState.time -= 1

func update_camera():
	# we really should not do this here but LevelBase _process() is called earlier
	# and the movement would be choppy that way
	level_base_obj.update_camera()

func _ready():
	GameState.state = GameState.GAME_STATE_PLAYING
	bounds_obj = Lib.get_first_group_member("bounds")
	level_base_obj = Lib.get_first_group_member("level_bases")

func _process(_delta):
	if GameState.transition_active:
		return
	
	frame += 1
	
	handle_direction_buttons()
	update_camera()
	
	if GameState.state == GameState.GAME_STATE_PLAYING:
		handle_action_buttons()
		reduce_timer()
		increase_energy()
	
	handle_face_animation()
	

func _unhandled_input(_event):
#	if event.is_action_pressed("ui_left"):
#		self.position.x += -1
#	elif event.is_action_pressed("ui_right"):
#		self.position.x += 1
#	elif event.is_action_pressed("action_first"):
#		self.position.y += 5
#	elif event.is_action_pressed("action_second"):
#		self.position.y += 20
	pass

