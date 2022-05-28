extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.connect("level_requested", self, "_on_level_requested")
	$BackgroundMusic.play()

func _on_level_requested(level_name):
	# load the new scene as instance
	delete_dynamic_scenes()
	var requested_level = load("res://Scenes/Level_Container/" + level_name + ".tscn").instance()
	print(requested_level)
	add_child(requested_level)

func delete_dynamic_scenes():
	# Delete all dynamic scenes from the current view
	get_tree().call_group("Dynamic_Scene", "queue_free")
	


