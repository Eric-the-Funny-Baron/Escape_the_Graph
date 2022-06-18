extends Node

var active: bool = true

func _on_Button_pressed():
	if active == false: return
	Signals.emit_signal("show_settings")
	Signals.emit_signal("touch_box_toggled")

func toggle_active():
	active = !active
	if active == false: set("modulate", Color(1,1,1,0.5))
	else: set("modulate", Color(1,1,1,1))
