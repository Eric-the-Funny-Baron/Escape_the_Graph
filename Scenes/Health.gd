extends Node

signal max_changed(new_max)
signal value_changed(new_amount)
signal depleted

export(int) var max_amount = 100 setget set_max
onready var current = max_amount setget set_current

func _ready():
	_initialise()
	Signals.connect("hint_given", self, "_on_hint_given")

func set_max(new_max):
	max_amount = max(1, new_max)
	emit_signal("max_changed", max_amount)
	
func set_current(new_value):
	current = clamp(new_value, 0, max_amount)
	emit_signal("value_changed", current)
	
	if (current == 0):
		emit_signal("depleted")

func _on_hint_given():
	set_current(20)

func _initialise():
	emit_signal("max_changed", max_amount)
	emit_signal("value_changed", current)
