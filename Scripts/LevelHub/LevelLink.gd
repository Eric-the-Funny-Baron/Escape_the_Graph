extends Node2D

enum ProblemType {SHORTEST_PATH, CAPACITY_PROBLEM, RELIABILITY_PROBLEM}
export (ProblemType) var type
export (int) var difficulty = 1


func _on_TouchBox_pressed():
	var type_letter
	match type:
		ProblemType.SHORTEST_PATH: type_letter = "S"
		ProblemType.CAPACITY_PROBLEM: type_letter = "C"
		ProblemType.RELIABILITY_PROBLEM: type_letter = "R"
			
	Signals.emit_signal("level_requested", "Level_" + type_letter + "_" + String(difficulty))
