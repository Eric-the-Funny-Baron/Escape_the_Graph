extends VideoPlayer


func _process(delta):
	if self.is_playing() == false:
		play()

func _ready():
	set_process(true)
