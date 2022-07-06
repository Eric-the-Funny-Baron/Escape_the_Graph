extends TextureButton

func _gui_input(event):
	if event is InputEventScreenTouch:
		pressed = !pressed
