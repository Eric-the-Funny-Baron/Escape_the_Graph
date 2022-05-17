extends Polygon2D


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
	for e in edges:
		active = active or e.selected
	if active:
		self.color = color1
	else:
		self.color = color2
