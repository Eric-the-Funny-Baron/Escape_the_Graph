extends AudioStreamPlayer

const BUS_LAYOUT: String = "res://default_bus_layout.tres"
const MASTER_INDEX: int = 0
const MASTER_NAME: String = "Master"
const MUSIC_NAME: String = "Music"
const EFFECTS_NAME: String = "Effects"

var music_index: int
var effects_index: int

func _ready() -> void:
	AudioServer.set_bus_layout(load(BUS_LAYOUT))

func set_music_volume(volume_percentage:float):
	var volume = -72.0 + 72.0 * volume_percentage
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(MUSIC_NAME), volume)

func set_effects_volume(volume_percentage:float):
	var volume = -72.0 + 72.0 * volume_percentage
	AudioServer.set_bus_volume_db(effects_index, volume)
