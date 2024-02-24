extends Node

var music_player: AudioStreamPlayer = null
var sfx_player: AudioStreamPlayer = null

var music_muted = false

var sound_effects = [
	preload("res://assets/sounds/blip9.wav"), # 0
	preload("res://assets/sounds/blip14.wav"), # 1
	preload("res://assets/sounds/blip9_short.wav"), # 2
	preload("res://assets/sounds/blip5_trim1.wav"), # 3
	preload("res://assets/sounds/blip5_trim2.wav"), # 4
	preload("res://assets/sounds/jingle1_chopped.wav"), # 5
]

func _ready():
	music_player = AudioStreamPlayer.new()
	music_player.bus = "Music"
	
	sfx_player = AudioStreamPlayer.new()
	sfx_player.bus = "Sfx"
	
	Lib.silence(sfx_player.connect("finished", self, "on_sfx_player_finished"))
	self.add_child(music_player)
	self.add_child(sfx_player)

func play_music(index: int):
	music_player.stop()
	music_player.stream = sound_effects[index]
	music_player.play()

func stop_music():
	music_player.stop()

func play_sfx(index: int):
	AudioServer.set_bus_mute(1, true)
	sfx_player.stop()
	sfx_player.stream = sound_effects[index]
	sfx_player.play()

func on_sfx_player_finished():
	AudioServer.set_bus_mute(1, music_muted)

func toggle_music_mute():
	music_muted = !music_muted
	AudioServer.set_bus_mute(1, music_muted)
