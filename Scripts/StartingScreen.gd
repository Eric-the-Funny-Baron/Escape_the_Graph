extends CanvasLayer

func _on_StartButton_pressed():
	Signals.emit_signal("change_visibility", "UI")
	Signals.emit_signal("level_requested", "Level_S_1")
