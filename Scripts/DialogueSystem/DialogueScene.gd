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
	Signals.emit_signal("dialog_finished") # is not always important, should be sent anyway

func set_new_dialog():
	if current_index >= maximum_index: 
		close_scene() 
		return
	for d in dialog_boxes:
		d.set_text(dialog_lines[current_index])
		d.display_text()
	
	current_index += 1	

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

func _input(event):
	if active == false: return
	if event is InputEventMouseButton and event.pressed:
		set_new_dialog()
		
