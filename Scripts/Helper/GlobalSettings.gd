extends Node

signal brightness_changed(value)
signal contrast_changed(value)

func update_master_volume(vol):
	AudioServer.set_bus_volume_db(0, vol)

func update_music_volume(vol):
	AudioServer.set_bus_volume_db(1, vol)
	
func update_sfx_volume(vol):
	AudioServer.set_bus_volume_db(2, vol)
	
func update_brightness(value):
	emit_signal("brightness_changed", value)
	
func update_contrast(value):
	emit_signal("contrast_changed", value)
	
