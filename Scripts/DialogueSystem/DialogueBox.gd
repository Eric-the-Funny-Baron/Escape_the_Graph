extends Control

func _ready():
	pass

func set_text(text:String):
	$DialogueText.text = text

func display_box():
	$BoxAnimations.play("DisplayBox")

func hide_box():
	$BoxAnimations.play_backwards("DisplayBox")

func display_text():
	$TextAnimations.play("DisplayText")
