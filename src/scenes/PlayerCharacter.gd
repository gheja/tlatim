extends Node2D

const ACTION_REPEAT_INTERVAL = 15

onready var face_sprite = $Visuals/FaceSprite

var frame = 0
var last_action_first_frame = null
var last_action_second_frame = null

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
		self.position.x += -1
	elif Input.is_action_pressed("ui_right"):
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
		face_sprite.frame = 4
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

func _ready():
	GameState.state = GameState.GAME_STATE_PLAYING

func _process(_delta):
	frame += 1
	
	handle_direction_buttons()
	
	if GameState.state == GameState.GAME_STATE_PLAYING:
		handle_action_buttons()
	
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
