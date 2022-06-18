extends Node

var active : bool = true
var help_name = ""

func _on_Button_pressed():
	if active == false: return
	Signals.emit_signal("dialogue_opened", help_name)
	

func toggle_active():
	active = !active
	if active == false: set("modulate", Color(1,1,1,0.5))
	else: set("modulate", Color(1,1,1,1))

func _on_HelpWindow_popup_hide():
	if active == false: return
	Signals.emit_signal("touch_box_toggled")
