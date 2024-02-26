extends Node2D

func _ready():
	self.hide()

func _process(_delta):
	if not self.visible and GameState.energy <= GameState.energy_max / 2:
		self.show()
		$AnimatedSprite.play("default")

func _on_Area2D_area_shape_entered(_area_rid, area, _area_shape_index, _local_shape_index):
	var other = area as Area2D
	
	if not self.visible:
		return
	
	var other_parent = other.get_parent()
	
	if not other_parent:
		return
	
	if other_parent.is_in_group("small_snowflakes") or other_parent.is_in_group("large_snowflakes"):
		AudioManager.play_sfx(0)
		GameState.energy = GameState.energy_max
		other_parent.queue_free()
		self.queue_free()
