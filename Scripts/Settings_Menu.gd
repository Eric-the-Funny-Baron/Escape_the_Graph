extends Popup


func _on_HSlider_mouse_exited():
	self.release_focus()


func _on_BrightnessSlider_value_changed(value):
	GlobalSettings.update_brightness(value)


func _on_MasterSlider_value_changed(value):
	if (value < 0):
		value = 72.0/50.0*value
	if (value > 0):
		value = 6.0/50.0*value
	GlobalSettings.update_master_volume(value)


func _on_MusicSlider_value_changed(value):
	if (value < 0):
		value = 72.0/50.0*value
	if (value > 0):
		value = 6.0/50.0*value
	GlobalSettings.update_music_volume(value)


func _on_EffectSlider_value_changed(value):
	if (value < 0):
		value = 72.0/50.0*value
	if (value > 0):
		value = 6.0/50.0*value
	GlobalSettings.update_sfx_volume(value)


func _on_ContrastSlider_value_changed(value):
	GlobalSettings.update_contrast(value)


func _on_Popup_about_to_show():
	Signals.emit_signal("game_pause_toggled")


func _on_Popup_popup_hide():
	Signals.emit_signal("game_pause_toggled")
