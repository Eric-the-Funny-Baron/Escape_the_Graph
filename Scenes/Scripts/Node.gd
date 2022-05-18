extends Polygon2D

class_name Level_Node

var edges = []

var is_start_target : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func define_as_start_target(size_factor : float, color : Color):
	self.color = color
	self.scale *= size_factor
	is_start_target = true

func add_edge(edge):
	edges.append(edge)

func update_state(color1 : Color, color2 : Color):
	var active = is_start_target
	if get_active_edges() != [] or is_start_target:
		self.color = color1
	else:
		self.color = color2

func get_active_edges():
	var active_edges = []
	for e in edges:
		if e.selected: active_edges.append(e)
	return active_edges
