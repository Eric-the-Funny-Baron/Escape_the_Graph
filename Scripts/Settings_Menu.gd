extends Popup


func _ready():
	$GridContainer/HSlider.release_focus()

func _on_HSlider_mouse_exited():
	self.release_focus()
