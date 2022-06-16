extends Node2D

export var room : int = 1
export var goal : bool = false
export var active : bool = true

var level_hub_name = ""
var open : bool = false

func _ready():
	level_hub_name = "LevelHub_" + String(room)
	$Door.frame = 1
	if active == false: $TouchBox.queue_free()
	

func _on_TouchBox_pressed():
	if not open: return # the function will not proceed until the door is open
	if goal: Signals.emit_signal("game_won_screen_requested")
	else: Signals.emit_signal("level_hub_requested", level_hub_name)

func set_as_opened():
	open = true
	if active: $Door.frame = 0
