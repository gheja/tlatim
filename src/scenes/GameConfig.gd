extends Node

#func save_config():
#	var config = ConfigFile.new()
#
#	config.set_value("game", "max_level_unlocked", maxLevelUnlocked)
#	config.set_value("settings", "music_enabled", musicEnabled)
#	config.set_value("settings", "sounds_enabled", soundsEnabled)
#	config.set_value("settings", "full_screen_enabled", fullScreenEnabled)
#	config.set_value("settings", "cpu_player_difficulty", cpu_player_difficulty)
#
#	config.save("user://config.cfg")

#func load_config():
#	var config = ConfigFile.new()
#	var err = config.load("user://config.cfg")
#
#	if err != OK:
#		return
#
#	maxLevelUnlocked = config.get_value("game", "max_level_unlocked", 0)
#	musicEnabled = config.get_value("settings", "music_enabled", true)
#	soundsEnabled = config.get_value("settings", "sounds_enabled", true)
#	fullScreenEnabled = config.get_value("settings", "full_screen_enabled", false)
#	cpu_player_difficulty = config.get_value("settings", "cpu_player_difficulty", 2)

func get_score(key: String):
	var config = ConfigFile.new()
	var err = config.load("user://config.cfg")
	
	if err != OK:
		return null
	
	return config.get_value("scores", "level:" + key, null)

func set_score(key: String, score: int):
	var config = ConfigFile.new()
	var err = config.load("user://config.cfg")
	
#	if err != OK:
#		return null
	
	config.set_value("scores", "level:" + key, score)
	config.save("user://config.cfg")

#func prepare_config():
#	var config = ConfigFile.new()
#	var err = config.load("user://config.cfg")
#
#	if err != OK:
#		save_config()
#		return

