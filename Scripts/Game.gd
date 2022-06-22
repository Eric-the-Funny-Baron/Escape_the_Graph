extends Node2D

# Attributes for Scene_Handling
var old_scene = null
var new_scene = null

# Attributes for Help_Dialogue
var current_help
var help_data

# Attribute to hold global information about all Levels
var level_log = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	Signals.connect("level_requested", self, "_on_level_requested")
	Signals.connect("level_hub_requested", self, "_on_level_hub_requested")
	Signals.connect("title_screen_requested", self, "_on_title_screen_requested")
	Signals.connect("game_over_screen_requested", self, "_on_game_over_screen_requested")
	Signals.connect("game_won_screen_requested", self, "_on_game_won_screen_requested")
	Signals.connect("change_visibility", self, "_on_change_visibility")
	Signals.connect("touch_box_toggled", self, "_on_touch_box_toggled")
	Signals.connect("help_update_requested", self, "_on_help_update_requested")
	Signals.connect("level_save_requested", self, "_on_level_save_requested")
	Signals.connect("level_load_requested", self, "_on_level_load_requested")
	Signals.connect("level_status_requested", self, "_on_level_status_requested")
	help_data = load_data("HelpDialogue.json")
	$BlendingLayer/Overlay.color = Color(0,0,0)
	_on_title_screen_requested(false)
	$UI.hide()

func _on_level_requested(level_name):
	var scene_path = "res://Scenes/Level/Level_Instances/" + level_name + ".tscn"
	_on_help_update_requested("Level_help")
	Signals.emit_signal("touch_box_toggled")
	switch_scene(scene_path)
	fade_in() # fade in calls fade out automatically
	yield($BlendingLayer/BlendingAnimation,"animation_finished")
	Signals.emit_signal("dialogue_opened", level_name)

func _on_level_hub_requested(level_hub_name):
	var scene_path = "res://Scenes/LevelHub/LevelHub_Instances/" + level_hub_name + ".tscn"
	_on_help_update_requested("Level_Hub_help")
	switch_scene(scene_path)
	fade_in()

func _on_title_screen_requested(should_fade_out:bool):
	Signals.emit_signal("sound_start_requested", "BackgroundMusic")
	var scene_path = "res://Scenes/StartingScreen.tscn"
	switch_scene(scene_path)
	if should_fade_out: fade_in()
	fade_out()
	$UI.hide()

func _on_game_over_screen_requested():
	Signals.emit_signal("sound_stop_requested", "BackgroundMusic")
	var scene_path = "res://Scenes/YouDied.tscn"
	level_log.clear() # all progress is deleted
	switch_scene(scene_path)
	fade_in()
	_on_change_visibility("UI")

func _on_game_won_screen_requested():
	Signals.emit_signal("sound_stop_requested", "BackgroundMusic")
	var scene_path = "res://Scenes/WinScreen.tscn" # HERE a concrete adress to the Won Scene is needed
	level_log.clear() # all progress is deleted
	switch_scene(scene_path)
	fade_in()
	_on_change_visibility("UI")
	
func _on_change_visibility(node_name):
	yield(get_node("BlendingLayer/BlendingAnimation"), "animation_finished")
	var node = get_node(node_name)
	var visibility = node.is_visible()
	if (visibility):
		node.hide()
	else:
		node.show()

func _on_touch_box_toggled():
	for t in get_tree().get_nodes_in_group("TouchBox"):
		t.visible = !t.visible

func _on_level_save_requested(level_name, solved, solve_num, solved_optimal):
	level_log[level_name] = {
		"solved" : solved,
		"solve_num" : solve_num,
		"solved_optimal" : solved_optimal
	}

func _on_level_load_requested(level_name):
	if level_name in level_log.keys():
		var level:Level = get_node(level_name)
		level.solved = level_log[level_name]["solved"]
		level.solve_num = level_log[level_name]["solve_num"]
		level.solved_optimal = level_log[level_name]["solved_optimal"]

func _on_level_status_requested(level_name, level_hub_name, level_link):
	if level_name in level_log:
		var link = get_node(level_hub_name).get_node(level_link)
		link.solved = level_log[level_name]["solved"]

func _on_help_update_requested(help_name):
	$UI/Node2D/Control/VBoxContainer/Control2/Help.help_name = help_name
	$UI/Node2D/HBoxContainer/Control2/VBoxContainer2/Control2/Help.help_name = help_name

func switch_scene(scene_path):
	old_scene = get_tree().get_nodes_in_group("Dynamic_Scene")
	new_scene = load(scene_path).instance()
	if "visible" in new_scene: new_scene.hide()
	else: new_scene.get_child(0).hide()
	add_child(new_scene)
	
func delete_old_dynamic_scenes():
	for s in old_scene:
		s.queue_free()
		
func fade_in():
	$BlendingLayer/BlendingAnimation.play("BlackScreen_Fading")

func fade_out():
	delete_old_dynamic_scenes()
	if "visible" in new_scene: new_scene.show()
	else: new_scene.get_child(0).show()
	old_scene = null
	new_scene = null
	$BlendingLayer/BlendingAnimation.play("BlackScreen_Fading_reverse")
	Signals.emit_signal("scene_switched")
	
func _on_BlendingAnimation_animation_finished(anim_name):
	match anim_name:
		"BlackScreen_Fading":
			fade_out()

func load_data(data):
	var file = File.new()
	file.open("res://Data/" + data, File.READ)
	var file_data = parse_json(file.get_as_text())
	file.close()
	return file_data
