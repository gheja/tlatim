extends Node2D

var speed_y = 1.0
var pos_x = 0.0
var pos_y = 0.0

func _ready():
	pos_x = float(randi() % 84)
	pos_y = float(randi() % 48)
	speed_y = 0.1 + randf() * 0.5

func _process(_delta):
	pos_x += GameState.wind
	pos_y += speed_y
	
	while pos_y > 48:
		pos_y += -48
	
	while pos_x > 84:
		pos_x += -84
	
	while pos_x < 0:
		pos_x += +84
	
	self.position.y = int(pos_y)
	self.position.x = int(pos_x)
