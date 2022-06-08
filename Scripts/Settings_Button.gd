extends Control


func _on_Button_pressed():
	Signals.emit_signal("game_pause_toggled")
