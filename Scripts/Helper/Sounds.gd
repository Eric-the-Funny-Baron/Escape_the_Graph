extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.connect("sound_start_requested", self, "_on_sound_start_requested")
	Signals.connect("sound_stop_requested", self, "_on_sound_stop_requested")

func _on_sound_start_requested(sound_name:String):
	self.get_node(sound_name).play()

func _on_sound_stop_requested(sound_name:String):
	self.get_node(sound_name).stop()
