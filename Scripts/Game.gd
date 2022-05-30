extends Node2D

# Attributes for Scene_Handling
var old_scene = null
var new_scene = null

# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.connect("level_requested", self, "_on_level_requested")
	Signals.connect("title_screen_requested", self, "_on_title_screen_requested")
	Signals.connect("game_over_screen_requested", self, "_on_game_over_screen_requested")
	Signals.connect("change_visibility", self, "_on_change_visibility")
	_on_title_screen_requested()

func _on_level_requested(level_name):
	var scene_path = "res://Scenes/Level/Level_Instances/" + level_name + ".tscn"
	switch_scene(scene_path)

func _on_title_screen_requested():
	$BackgroundMusic.play()
	var scene_path = "res://Scenes/StartingScreen.tscn"
	switch_scene(scene_path)

func _on_game_over_screen_requested():
	$BackgroundMusic.stop()
	_on_change_visibility("UI")
	var scene_path = "res://Scenes/YouDied.tscn"
	switch_scene(scene_path)
	
func _on_change_visibility(node_name):
	var node = get_node(node_name)
	var visibility = node.is_visible()
	if (visibility):
		node.hide()
	else:
		node.show()

func switch_scene(scene_path):
	old_scene = get_tree().get_nodes_in_group("Dynamic_Scene")
	new_scene = load(scene_path).instance()
	if "visible" in new_scene: new_scene.visible = false
	add_child(new_scene)
	$BlendingLayer/BlendingAnimation.play("BlackScreen_Fading")
	
func delete_old_dynamic_scenes():
	for s in old_scene:
		s.queue_free()
	
func _on_BlendingAnimation_animation_finished(anim_name):
	match anim_name:
		"BlackScreen_Fading":
			delete_old_dynamic_scenes()
			if "visible" in new_scene: new_scene.visible = true
			old_scene = null
			new_scene = null
			$BlendingLayer/BlendingAnimation.play("BlackScreen_Fading_reverse")
	

func _on_LevelLink_pressed():
	Signals.emit_signal("level_requested", "Level_S_1")

