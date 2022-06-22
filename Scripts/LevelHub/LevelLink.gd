extends Node2D

enum ProblemType {SHORTEST_PATH, CAPACITY_PROBLEM, RELIABILITY_PROBLEM}
export (ProblemType) var type
export (int) var difficulty = 1



var solved: bool = false
var level_name = ""

func _ready():
	var type_letter
	match type:
		ProblemType.SHORTEST_PATH: type_letter = "S"
		ProblemType.CAPACITY_PROBLEM: type_letter = "C"
		ProblemType.RELIABILITY_PROBLEM: type_letter = "R"
	level_name = "Level_" + type_letter + "_" + String(difficulty)
	Signals.emit_signal("level_status_requested", level_name, get_node("..").get_name(), get_name())
	if solved:
		$LevelLink_Graphic.color = Color(0.61, 1, 0.51)


func _on_TouchBox_pressed():
	Signals.emit_signal("sound_start_requested", "SelectionSound")	
	Signals.emit_signal("level_requested", level_name)
