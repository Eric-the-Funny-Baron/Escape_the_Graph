extends Node
signal value_changed(new_amount)
signal depleted

export(int) var max_amount = 100
onready var current = max_amount 

func _ready():
	set_current(0)
	Signals.connect("hint_given", self, "_on_hint_given")
	Signals.connect("points_taken", self, "_points_taken")
	Signals.connect("points_given", self, "_points_given")
	
func set_current(change):
	var new_value = current - change
	current = clamp(new_value, 0, max_amount)
	emit_signal("value_changed", current)
	
	if (current == 0):
		emit_signal("depleted")

func _on_hint_given():
	set_current(20)

func _points_taken(points):
	set_current(points)

func _points_given(points):
	set_current(-points)
