extends Control

var credits_texts = [
	"Code:\n  gheja",
	"Graphics:\n  gheja",
	"Music:\n  Avgvsta, gheja",
	"Sounds:\n  trix, gheja",
	"Font:\n  Brian Swetland",
]

var credits_index = -1

func _unhandled_input(event):
	if event.is_action_pressed("action_first") or event.is_action_pressed("action_second"):
		Signals.emit_signal("switch_to_level_selection")

func step_credits():
	credits_index = (credits_index + 1) % credits_texts.size()
	
	$CreditsLabel.bbcode_text = credits_texts[credits_index]

func _ready():
	AudioManager.play_music(6)
	
	if not GameState.intro_played:
		$StartButtonOverlay.hide()
		$IntroAnimation.play("start")
		$CreditsLabel.bbcode_text = ""
		$TitleLabel.hide()
		GameState.intro_played = true
	else:
		$IntroAnimation.play("loop")
		$CreditsTimer.start()
		$StartButtonOverlay.show()
		step_credits()

func _on_CreditsTimer_timeout():
	step_credits()

func _on_IntroAnimation_animation_finished():
	if $IntroAnimation.animation == "start":
		$IntroAnimation.play("loop")
		$TitleLabel.show()
		$CreditsTimer.start()
		step_credits()
		$StartButtonOverlay.show()
