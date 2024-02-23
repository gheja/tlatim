extends Node2D

func is_complete():
	if $AnimatedSprite.frame >= $AnimatedSprite.frames.get_frame_count($AnimatedSprite.animation) - 1:
		return true
	
	return false

func increment():
	if is_complete():
		return
	
	$AnimatedSprite.frame += 1
	
	if is_complete():
		Signals.emit_signal("object_completed")

func _ready():
	$AnimatedSprite.frame = 0


func _on_Area2D_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	var other = area as Area2D
	
	var other_parent = other.get_parent()
	
	if not other_parent:
		return
	
	if other_parent.is_in_group("small_snowflakes"):
		increment()
		other_parent.queue_free()
	elif other_parent.is_in_group("large_snowflakes"):
		increment()
		increment()
		increment()
		other_parent.queue_free()
	
	if is_complete():
		$Area2D.queue_free()