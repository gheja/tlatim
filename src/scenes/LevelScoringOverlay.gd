extends Control

var val1 = 30
var val2 = 50
var val3 = 15

var tmp_score = 0
var total_score = 0

var phase = 0

func _process(_delta):
	$Foreground/RightText.bbcode_text = "[right]" + str(val1) + "\n" + str(val2) + "\n" + str(val3) + "\n[/right]" 
	
	if tmp_score > 0:
		$Foreground/PlusText.bbcode_text = "[right]+" + str(tmp_score) + "[/right]"
	else:
		$Foreground/PlusText.bbcode_text = ""
	
	$Foreground/TotalScoreText.bbcode_text = "[right][b]" + str(total_score) + "[/b][/right]"

func next_phase():
	$Timer.stop()
	
	if phase == 6:
		$ScoringCompletedTimer.start()
		return
	
	phase += 1
	$PhaseStartTimer.start()

func step_val(val, step_size, step_multiplier):
	val -= step_size
	tmp_score += step_size * step_multiplier
	return val

func step_total_score(step_size):
	if tmp_score > step_size:
		total_score += step_size
		tmp_score -= step_size
	else:
		total_score += tmp_score
		tmp_score = 0

func _on_Timer_timeout():
	if phase == 1:
		if val1 == 0:
			next_phase()
		else:
			val1 = step_val(val1, 1, 10)
	elif phase == 2:
		if tmp_score == 0:
			next_phase()
		else:
			step_total_score(25)
	elif phase == 3:
		if val2 == 0:
			next_phase()
		else:
			val2 = step_val(val2, 1, 10)
	elif phase == 4:
		if tmp_score == 0:
			next_phase()
		else:
			step_total_score(25)
	elif phase == 5:
		if val3 == 0:
			next_phase()
		else:
			val3 = step_val(val3, 1, 10)
	elif phase == 6:
		if tmp_score == 0:
			next_phase()
		else:
			step_total_score(25)

func _on_PhaseStartTimer_timeout():
	$Timer.start()

func _on_ScoringCompletedTimer_timeout():
	$AnimationPlayer.play("continue")
	Signals.emit_signal("scoring_completed")