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
	# PLAY ROBOT SOUND
	Signals.emit_signal("sound_start_requested", "")


func _on_TouchBox_pressed():
	$Arrow.color = Color(0.12, 0.11, 0.25)
	Signals.emit_signal("continue_pressed")

func _on_TouchBox_released():
	$Arrow.color = Color(0.67, 0.28, 0.67)
