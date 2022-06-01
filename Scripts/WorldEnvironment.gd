extends WorldEnvironment

func _ready():
	GlobalSettings.connect("brightness_changed", self, "_on_brightness_changed")
	GlobalSettings.connect("contrast_changed", self, "_on_contrast_changed")
	
	
func _on_brightness_changed(value):
	environment.adjustment_brightness = value
	

func _on_contrast_changed(value):
	environment.adjustment_contrast = value
