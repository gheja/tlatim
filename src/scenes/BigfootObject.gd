extends Node2D

var current_target_object: Position2D = null
var target_objects = []
var target_object_index = -1

var pos_x = 0.0
var pos_y = 0.0

var was_hit = false

func _ready():
	target_objects = get_tree().get_nodes_in_group("bigfoot_targets")
	$AnimatedSprite.play("default")
	
	pos_x = self.position.x
	pos_y = self.position.y
	was_hit = false
	
	self.hide()

func _on_Area2D_area_shape_entered(_area_rid, area, _area_shape_index, _local_shape_index):
	var other = area as Area2D
	
	if not self.visible:
		return
	
	var other_parent = other.get_parent()
	
	if not other_parent:
		return
	
	if other_parent.is_in_group("small_snowflakes") or other_parent.is_in_group("large_snowflakes"):
		$AnimatedSprite.play("oops")
		Signals.emit_signal("oops")
		other_parent.queue_free()
		$Area2D.queue_free()
		was_hit = true

func _process(_delta):
	if not current_target_object or was_hit:
		return
	
	if abs(self.position.x - current_target_object.position.x) < 0.2 and abs(self.position.y - current_target_object.position.y) < 0.2:
		# arrived!
		current_target_object = null
		self.hide()
		$Timer.start()
		return
	
	if self.position.x - current_target_object.position.x > 0.2:
		pos_x = pos_x - 0.2
	elif self.position.x - current_target_object.position.x < -0.2:
		pos_x = pos_x + 0.2
	
	if self.position.y - current_target_object.position.y > 0.2:
		pos_y = pos_y - 0.2
	elif self.position.y - current_target_object.position.y < -0.2:
		pos_y = pos_y + 0.2
	
	if self.position.x < current_target_object.position.x:
		$AnimatedSprite.flip_h = true
	else:
		$AnimatedSprite.flip_h = false
	
	self.position.x = int(pos_x)
	self.position.y = int(pos_y)

func _on_Timer_timeout():
	target_object_index = (target_object_index + 1) % target_objects.size()
	current_target_object = target_objects[target_object_index]
	self.show()

