extends Node2D

func on_game_won():
	$AnimatedSprite.play("happy")

func _ready():
	$AnimatedSprite.play("default")
	Signals.connect("game_won", self, "on_game_won")
