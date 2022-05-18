extends Line2D

class_name Edge

export (Color) var unselected_color
export (Color) var selected_color
export var padding : float = 0

var selected : bool = false
var nodes = []



# Called when the node enters the scene tree for the first time.
func _ready():
	default_color = unselected_color
	$ContainerLayer/WeightValue.set("custom_colors/font_color", default_color)
	
	# ==========================================================================
	# Building the TouchBox
	# ==========================================================================
	var touch_box = ConvexPolygonShape2D.new()
	var start_point : Vector2 = self.points[0] # returns the start point
	var end_point : Vector2 = self.points[1] # returns the end point
	var direction_vector = end_point - start_point
	var normal_vector = Vector2(-direction_vector.y, direction_vector.x).normalized()
	var point_offset = normal_vector * (self.width / 2 + padding)
	
	var start_up = start_point + point_offset
	var start_down = start_point - point_offset
	var end_up = end_point + point_offset
	var end_down = end_point - point_offset
	
	touch_box.set_point_cloud([start_up, start_down, end_down, end_up])
	$TouchBox.set_shape(touch_box)
	# ==========================================================================
	$ContainerLayer/WeightValue.rect_position =  start_point + direction_vector * 0.5
	#$ContainerLayer/WeightValue.rect_position += $ContainerLayer/WeightValue.rect_size * 0.5 * normal_vector
	$ContainerLayer/WeightValue.rect_position += normal_vector * (self.width + padding * 0.5)

func _on_TouchScreenButton_pressed():
	selected = !selected
	var new_color = unselected_color.linear_interpolate(selected_color, float(selected))
	self.default_color = new_color
	$ContainerLayer/WeightValue.set("custom_colors/font_color", default_color)
	for n in nodes:
		n.update_state(selected_color, unselected_color)
	Signals.emit_signal("edge_status_changed")

func set_weight(text):
	$ContainerLayer/WeightValue.text = str(text)

func add_node(node):
	nodes.append(node)
