extends Node

const GAME_STATE_UNKNOWN = 0
const GAME_STATE_INTRO = 1
const GAME_STATE_PLAYING = 2
const GAME_STATE_WON = 3
const GAME_STATE_LOST = 4

var state = GAME_STATE_UNKNOWN
var transition_active = false
var current_level_key = "unknown"
var intro_played = false
# player hit an object that they should not have hit
var oops_happened = false

var wind = -0.33

var energy = 100
var energy_max = 100

var time = 50
var time_max = 30

# will be read and written by LevelSelectionScene
var level_index_last = 0
var level_index_max = -1
