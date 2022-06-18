extends Control

func _ready():
	$LineAnimations.play("SpeakLineMotion")

func display_ai():
	$AI_Animations.play("Display_AI")

func hide_ai():
	$AI_Animations.play_backwards("Display_AI")
