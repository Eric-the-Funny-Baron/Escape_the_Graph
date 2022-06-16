extends CanvasLayer

func _ready():
	Signals.emit_signal("sound_start_requested", "Win_Jingle")
	yield(get_tree().create_timer(20), "timeout")
	Signals.emit_signal("title_screen_requested", true)
