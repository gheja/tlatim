extends Node

const GAME_STATE_UNKNOWN = 0
const GAME_STATE_INTRO = 1
const GAME_STATE_PLAYING = 2
const GAME_STATE_WON = 3
const GAME_STATE_LOST = 4

var wind = -0.33
var energy = 100
var state = GAME_STATE_UNKNOWN
