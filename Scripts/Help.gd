extends Node

func _on_Button_pressed():
	$Node2D/HelpWindow.popup()
	Signals.emit_signal("touch_box_toggled")



func _on_HelpWindow_popup_hide():
	Signals.emit_signal("touch_box_toggled")
