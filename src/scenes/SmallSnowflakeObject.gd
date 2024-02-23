extends Node2D

var pos_x = 0.0
var pos_y = 0.0
var speed_y = 1.0

func _ready():
	var player = Lib.get_player_object()
	
	pos_x = player.position.x
	pos_y = player.position.y + 6
	speed_y = 0.4

func _process(_delta):
	pos_x += GameState.wind
	pos_y += speed_y
	
	self.position.y = int(pos_y)
	self.position.x = int(pos_x)
