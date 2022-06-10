extends Control


func _on_Button_pressed():
	Signals.emit_signal("touch_box_toggled")
