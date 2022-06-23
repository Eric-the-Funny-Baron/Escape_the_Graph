extends Line2D

class_name Edge

export var padding : float = 0

enum Edge_States {UNSELECTED, SELECTABLE, SELECTED}

var state = Edge_States.UNSELECTED
var hint_showing:bool = false
var solution_showing:bool = false
var nodes = []



# Called when the node enters the scene tree for the first time.
func _ready():
	default_color = get_state_color()
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
	$ContainerLayer.position =  start_point + direction_vector * (0.5 + rand_range(-0.15, 0.15))
	#$ContainerLayer.position += direction_vector.normalized().rotated(0.5*PI) * $ContainerLayer/WeightValue.rect_size.y * 0.5
	var rotation = Vector2(1.0, 0).angle_to(direction_vector.normalized())
	if $ContainerLayer.position.y < get_viewport_rect().size.y * 0.5:
		$ContainerLayer.rotation_degrees = 180

func _on_TouchScreenButton_pressed():
	update_state_on_touch()
	default_color = get_state_color()
	$ContainerLayer/WeightValue.set("custom_colors/font_color", default_color)
	$ContainerLayer/WeightValue/OrientationLine.set("custom_colors/font_color", default_color)
	Signals.emit_signal("edge_status_changed")

func set_weight(text):
	$ContainerLayer/WeightValue.text = str(text)

func add_node(node):
	nodes.append(node)

func update_state_on_touch():
	var check_sum = 0
	for n in nodes:
		check_sum += n.state
	
	# SELECTABLE x CLICK -> SELECTED
	if state == Edge_States.SELECTABLE:
		state = Edge_States.SELECTED
		Signals.emit_signal("sound_start_requested", "SelectionSound")
		for n in nodes:
			if n.state == 1: # 1 represents Node state ACTIVE
				n.set_visited()
			elif n.state == 0: # 0 represents Node state DEFAULT
				n.set_active()
	
	# SELECTED x CLICK -> SELECTABLE
	elif state == Edge_States.SELECTED and check_sum == 3:
		state = Edge_States.SELECTABLE
		Signals.emit_signal("sound_start_requested", "SelectionSound")
		for n in nodes:
			if n.state == 1: # 1 represents Node state ACTIVE
				n.set_default()
			elif n.state == 2: # 2 represents Node state VISITED
				n.set_active()

func change_selectable():
	var check_sum = 0
	for n in nodes:
		check_sum += n.state
	if check_sum == 0: state = Edge_States.UNSELECTED
	elif check_sum == 1: state = Edge_States.SELECTABLE
	elif check_sum == 2: state = Edge_States.UNSELECTED
	#elif check_sum == 3: state = Edge_States.UNSELECTED
	#elif check_sum == 4: state = Edge_States.SELECTED
	default_color = get_state_color()
	$ContainerLayer/WeightValue.set("custom_colors/font_color", default_color)
	$ContainerLayer/WeightValue/OrientationLine.set("custom_colors/font_color", default_color)

func change_state(_state):
	state = _state
	default_color = get_state_color()
	$ContainerLayer/WeightValue.set("custom_colors/font_color", default_color)
	$ContainerLayer/WeightValue/OrientationLine.set("custom_colors/font_color", default_color)

func get_state_color() -> Color:
	if solution_showing: return $ColorTable.solution_color
	match state:
		Edge_States.UNSELECTED: return $ColorTable.default_color.linear_interpolate($ColorTable.hint_color, 0.4 * float(hint_showing))
		Edge_States.SELECTABLE: return $ColorTable.selectable_color.linear_interpolate($ColorTable.hint_color, 0.4 * float(hint_showing))
		Edge_States.SELECTED:   return $ColorTable.selected_color.linear_interpolate($ColorTable.hint_color, 0.4 * float(hint_showing))
		_:                      return $ColorTable.default_color.linear_interpolate($ColorTable.hint_color, 0.4 * float(hint_showing))
