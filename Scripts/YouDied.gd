extends CanvasLayer

func _ready():
	yield(Signals, "scene_switched")	
	Signals.emit_signal("sound_start_requested", "GameOverSound")
	yield(get_tree().create_timer(10), "timeout")
	Signals.emit_signal("title_screen_requested", true)


func _on_Button_pressed():
	Signals.emit_signal("title_screen_requested", true)
