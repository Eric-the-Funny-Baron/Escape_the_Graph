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
	var requested_level = load("res://Scenes/Level/Level_Instances/" + level_name + ".tscn").instance()
	add_child(requested_level)

func delete_dynamic_scenes():
	# Delete all dynamic scenes from the current view
	var scenes = get_tree().get_nodes_in_group("Dynamic_Scene")
	for s in scenes:
		remove_child(s)
		s.free()
	




func _on_LevelLink_pressed():
	Signals.emit_signal("level_requested", "Level_S_1")
