extends Control

var dialogue_scenes : Dictionary = {}
var current_dialogue_scene = null
var dialog_boxes
var active = false

var current_index : int
var maximum_index : int
var dialog_lines = []

func _ready():
	Signals.connect("dialogue_opened", self, "_open_scene")
	Signals.connect("evaluation_requested", self, "_on_evaluation_requested")
	Signals.connect("continue_pressed", self, "_on_continue_pressed")
	Signals.connect("fused_dialogue_opened", self, "open_fused_dialog")
	Signals.connect("dialog_fuse_requested", self, "fuse_dialog")
	
	# Loading of all Dialogue Data =================
	var file = File.new()
	file.open("res://Data/AI_Dialogue.json", File.READ)
	dialogue_scenes = parse_json(file.get_as_text())
	file.close()
	# ==============================================
	
	dialog_boxes = get_tree().get_nodes_in_group("DialogueBox")
	visible = false

func _open_scene(scene_name):
	current_dialogue_scene = dialogue_scenes[scene_name]
	Signals.emit_signal("touch_box_toggled")
	for e in get_tree().get_nodes_in_group("UI_Buttons"):
		e.toggle_active()
	for e in get_tree().get_nodes_in_group("Level_Button"):
		e.set_disabled(true)
	visible = true
	active = true
	current_index = 0
	maximum_index = dialogue_scenes[scene_name].size()
	
	dialog_lines = dialogue_scenes[scene_name].values()
	
	$DialogSceneAnimations.play("BackgroundFade")
	$CenterContainer/SizeContainer/AI.display_ai()
	for d in dialog_boxes:
		d.display_box()
	
	set_new_dialog()

func close_scene():
	current_dialogue_scene = null
	active = false
	Signals.emit_signal("touch_box_toggled")
	dialog_lines.clear()
	for d in dialog_boxes:
		d.hide_box()
	$CenterContainer/SizeContainer/AI.hide_ai()
	$DialogSceneAnimations.play_backwards("BackgroundFade")
	yield($DialogSceneAnimations, "animation_finished")
	visible = false
	for e in get_tree().get_nodes_in_group("UI_Buttons"):
		e.toggle_active()
	for e in get_tree().get_nodes_in_group("Level_Button"):
		e.set_disabled(false)
	Signals.emit_signal("dialog_finished") # is not always important, should be sent anyway

func set_new_dialog():
	if current_index >= maximum_index: 
		close_scene() 
		return
	for d in dialog_boxes:
		d.set_text(dialog_lines[current_index])
		d.display_text()
	
	current_index += 1

func open_fused_dialog(dialog_1, dialog_2):
	current_dialogue_scene = dialogue_scenes[dialog_1]
	var i = 0 # index
	for d in dialogue_scenes[dialog_2].keys():
		current_dialogue_scene["concat_" + String(i)] = dialogue_scenes[dialog_2][d]
		i += 1
	for e in get_tree().get_nodes_in_group("UI_Buttons"):
		e.toggle_active()
	for e in get_tree().get_nodes_in_group("Level_Button"):
		e.set_disabled(true)
	visible = true
	active = true
	current_index = 0
	maximum_index = current_dialogue_scene.size()
	
	dialog_lines = current_dialogue_scene.values()
	
	$DialogSceneAnimations.play("BackgroundFade")
	$CenterContainer/SizeContainer/AI.display_ai()
	for d in dialog_boxes:
		d.display_box()
	
	set_new_dialog()		

func fuse_dialog(dialog_1, dialog_2):
	var new_key = dialog_1 + dialog_2
	var new_content = {}
	for d in dialogue_scenes[dialog_1].keys():
		new_content[dialog_1 + d] = dialogue_scenes[dialog_1][d]
	for d in dialogue_scenes[dialog_2].keys():
		new_content[dialog_2 + d] = dialogue_scenes[dialog_2][d]
	
	dialogue_scenes[new_key] = new_content
	

func _on_evaluation_requested(best_value, value):
	var scene_name = "Level_Evaluation"
	current_dialogue_scene = dialogue_scenes[scene_name]
	for e in get_tree().get_nodes_in_group("UI_Buttons"):
		e.toggle_active()
	visible = true
	active = true
	current_index = 0
	maximum_index = dialogue_scenes[scene_name].size()
	
	dialog_lines = dialogue_scenes[scene_name].values()
	dialog_lines[0] = dialog_lines[0] % [best_value, value]
	
	$DialogSceneAnimations.play("BackgroundFade")
	$CenterContainer/SizeContainer/AI.display_ai()
	for d in dialog_boxes:
		d.display_box()
	
	set_new_dialog()

func _on_continue_pressed():
	if active == false: return
	set_new_dialog()
		
