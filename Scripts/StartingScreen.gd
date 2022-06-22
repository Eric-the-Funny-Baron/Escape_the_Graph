extends CanvasLayer

func _on_StartButton_pressed():
	Signals.emit_signal("level_hub_requested", "LevelHub_1")
	Signals.emit_signal("change_visibility", "UI")
	Signals.emit_signal("sound_start_requested", "SelectionSound")
	yield(Signals, "scene_switched")
	Signals.emit_signal("dialogue_opened", "Intro_Scene")
	

