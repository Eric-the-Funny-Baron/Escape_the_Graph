extends Button

export (String) var level_name = "Level"

func _on_LevelLink_pressed():
	Signals.emit_signal("level_hub_requested", level_name)
	print("Signal sent")
