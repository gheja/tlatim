extends Node

var music_player: AudioStreamPlayer = null
var sfx_player: AudioStreamPlayer = null

var music_muted = false
var music_temp_muted = false
var current_music_index = -1

var sound_effects = [
	preload("res://assets/sounds/blip9.wav"), # 0
	preload("res://assets/sounds/blip14.wav"), # 1
	preload("res://assets/sounds/blip9_short.wav"), # 2
	preload("res://assets/sounds/blip5_trim1.wav"), # 3
	preload("res://assets/sounds/blip5_trim2.wav"), # 4
	preload("res://assets/sounds/jingle1_chopped.wav"), # 5
	preload("res://assets/music/intro_based_on_valentine_1_by_avgvsta_on_opengameart.ogg"), # 6
	preload("res://assets/music/main_based_on_gossiping_by_avgvsta_on_opengameart.ogg"), # 7
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
	if current_music_index == index:
		return
	
	current_music_index = index
	
	music_player.stop()
	music_player.stream = sound_effects[index]
	music_player.play()

func stop_music():
	current_music_index = -1
	
	music_player.stop()

func update_music_mute():
	AudioServer.set_bus_mute(1, music_muted || music_temp_muted || sfx_player.playing)

func set_music_temp_mute(value: bool):
	music_temp_muted = value
	update_music_mute()

func play_sfx(index: int):
	sfx_player.stop()
	sfx_player.stream = sound_effects[index]
	sfx_player.play()
	update_music_mute()

func on_sfx_player_finished():
	update_music_mute()
