extends Polygon2D

class_name Level_Node

enum Node_States {DEFAULT = 0, ACTIVE = 1, VISITED = 2}

var is_start_target : bool = false
var state = Node_States.DEFAULT
var hint_showing:bool = false
var edges = []

# Called when the node enters the scene tree for the first time.
func _ready():
	color = get_state_color().linear_interpolate($ColorTable.selected_color, float(is_start_target))

func define_as_start_target(size_factor : float):
	color = $ColorTable.selected_color
	self.scale *= size_factor
	is_start_target = true

func add_edge(edge):
	edges.append(edge)

func get_active_edges():
	var active_edges = []
	for e in edges:
		if e.state == Edge.Edge_States.SELECTED: active_edges.append(e)
	return active_edges

func set_default():
	state = Node_States.DEFAULT
	color = get_state_color()

func set_active():
	state = Node_States.ACTIVE
	color = get_state_color()

func set_visited():
	state = Node_States.VISITED
	color = get_state_color()

func get_state_color() -> Color:
	match state:
		Node_States.DEFAULT: return $ColorTable.default_color.linear_interpolate($ColorTable.hint_color, 0.5 * float(hint_showing))
		Node_States.ACTIVE:  return $ColorTable.active_color.linear_interpolate($ColorTable.hint_color, 0.5 * float(hint_showing))
		Node_States.VISITED: return $ColorTable.selected_color.linear_interpolate($ColorTable.hint_color, 0.5 * float(hint_showing))
		_:                   return $ColorTable.default_color.linear_interpolate($ColorTable.hint_color, 0.5 * float(hint_showing))
