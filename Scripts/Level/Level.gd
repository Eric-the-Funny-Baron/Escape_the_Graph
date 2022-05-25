extends Node2D

##
## This is the Level class of the game 'Escape the Graph'
##
## @desc:
##		The Level class will provide the functionality to generate Levels,
##		the possibility to interact with them and the system to evaluate the interaction.
##

class_name Level

# Parameters
export (PackedScene) var node_scene
export (PackedScene) var edge_scene
export var margin = 200.0 # border margin in the scene
export var randomness = 0.1 # randomness of placement
export var nodes : int = 1 # number of nodes in the graph
export var edges : int = 1 # number of edges in the graph
enum ProblemType {SHORTEST_PATH, CAPACITY_PROBLEM, RELIABILITY_PROBLEM}
export (ProblemType) var type 
export var minimal_weight = 0.0 # minimal weight of edges
export var maximum_weight = 10.0 # maximum weight of edges
export (int, 1, 100) var start_to_target_distance = 1
export (int, 1, 10000) var iteration_limit = 10 # maximum iterations in the force_directed algorithm
export (float, 0, 100) var threshold # minimal threshold the force equilibrium should reach
export var repulsive_factor = 2.0
export var attractive_factor = 1.0
export var ideal_length = 100.0
export var cooling_factor = 0.99

# Attributes
var screen_size
var subdivisions = 1
var level_graph = Graph.new()
var solution = {}
var solution_path = []
var best_weight # best weight
var worst_weight # worst_weight


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	screen_size = get_viewport_rect().size
	subdivisions = int(ceil(log(nodes) / log(2)))

	Signals.connect("edge_status_changed", self, "_on_Edge_status_changed")
	
	build_level()

func build_level():
	generate_graph()
	render_graph()
	
	# Dijkstra Calculation =========================================================================
	var dijkstra = null # initial dijkstra table
	solution_path.clear()
	solution.clear()
	match type:
		ProblemType.SHORTEST_PATH: dijkstra = Shortest_Path.new(level_graph)
		ProblemType.CAPACITY_PROBLEM: dijkstra = Capacity_Problem.new(level_graph)
		ProblemType.RELIABILITY_PROBLEM: dijkstra = Reliability_Problem.new(level_graph)
	worst_weight = dijkstra.get_worst_weight()
	solution = dijkstra.solve_path_problem()
	best_weight = solution['totalWeight']
	for i in range(solution['path'].size()-1):
		var edge = SetMethods.intersect(solution['path'][i].edges, solution['path'][i + 1].edges)
		if edge.size() > 0:solution_path.append(edge[0])
		else: print("edge is empty, the edge sets where: ", solution['path'][i].edges, solution['path'][i + 1].edges)
	# ==============================================================================================
	
	level_graph.start.set_active()
	_on_Edge_status_changed()
	
func generate_graph():
	var block_size:Vector2 = (screen_size - Vector2(margin, margin))
	var circle_vector = Vector2(0.75, 0) #* min(block_size.x, block_size.y) * 0.5
	var rotation_value = 2 * PI / nodes
	var screen_base = Transform2D(Vector2(block_size.x * 0.5, 0), \
								  Vector2(0, block_size.y * 0.5), \
								 (Vector2(block_size) + Vector2(margin, margin)) * 0.5)
	
	# === Node Distribution === 
	for _i in range(nodes):
		var node: Level_Node = node_scene.instance()
		var epsilon_x = rand_range(-block_size.x/subdivisions, block_size.x/subdivisions) * randomness
		var epsilon_y = rand_range(-block_size.y/subdivisions, block_size.y/subdivisions) * randomness
		var epsilon = Vector2(epsilon_x, epsilon_y)
		node.position = screen_base.xform(circle_vector) + epsilon#+ block_size * 0.5 + Vector2(margin, margin) * 0.5 + epsilon
		level_graph.nodes.append(node)
		circle_vector = circle_vector.rotated(rotation_value)
	
	# === Edge Building === 
	for i in range(min(edges, int(nodes*(nodes-1)/2.0))):
		var edge = null # initial empty edge
		
		# while edge is empty or exists already, new tries of building a new edge are executed
		while edge == null or level_graph.edge_exists_already(edge):
			var node1 = randi() % level_graph.nodes.size()
			var node2
			
			if i < nodes - 1: node2 = (node1 + 1) % level_graph.nodes.size()
			else: node2 = randi() % level_graph.nodes.size()
				
			while node2 == null or node2 == node1:
				node2 = randi() % level_graph.nodes.size()
			var random_weight = rand_range(minimal_weight, maximum_weight)
			if type == ProblemType.SHORTEST_PATH or type == ProblemType.CAPACITY_PROBLEM: random_weight = int(random_weight)
			else: random_weight = stepify(random_weight, 0.01)
			
			edge = level_graph.create_edge(level_graph.nodes[node1], level_graph.nodes[node2], random_weight)
		level_graph.add_edge(edge)
	
	level_graph.define_start()
	level_graph.define_target(start_to_target_distance)
	level_graph.start.define_as_start_target(2)
	level_graph.target.define_as_start_target(2)

func force_directed_correction():
	var iterations = 1
	var forces = [Vector2(threshold, threshold)] # list of all forces with initial start vector, which will be removed later
	var cooling = 1
	while iterations < iteration_limit and forces.max().length() > threshold:
		forces = [] 
		
		for u in range(level_graph.nodes.size()):
			var repulsive_force = Vector2.ZERO
			var attractive_force = Vector2.ZERO
			var adjacent_nodes = level_graph.get_neighbours(level_graph.nodes[u])
			var all_other_nodes = SetMethods.difference(level_graph.nodes, adjacent_nodes)
			all_other_nodes = SetMethods.difference(level_graph.nodes, [level_graph.nodes[u]])
			
			# Calculation of the repulsive force per node
			for v in all_other_nodes:
				var distance_squared =  (v.position - level_graph.nodes[u].position).length_squared()
				var unit_vector_vu = (level_graph.nodes[u].position - v.position).normalized()
				repulsive_force += repulsive_factor / distance_squared * unit_vector_vu
			
			# Calculation of the attractive force per node
			for v in adjacent_nodes:
				var distance = (v.position - level_graph.nodes[u].position).length()
				var unit_vector_uv = (v.position - level_graph.nodes[u].position).normalized()
				attractive_force += attractive_factor * log(distance / ideal_length) * unit_vector_uv
			var force_u = repulsive_force + attractive_force
			forces.append(force_u)
		
		for u in range(level_graph.nodes.size()):
			var new_position = level_graph.nodes[u].position + cooling * forces[u]
			new_position.x = clamp(new_position.x, margin, screen_size.x - margin)
			new_position.y = clamp(new_position.y, margin, screen_size.y - margin)
			level_graph.nodes[u].position = new_position
			
		iterations += 1
		cooling *= cooling_factor

func render_graph():
	for edge in level_graph.edges:
		var render_edge = edge_scene.instance()
		render_edge.clear_points()
		render_edge.set_weight(edge['weight'])
		for n in edge['targeting'].keys():
			render_edge.add_node(n)
			n.add_edge(render_edge)
			render_edge.add_point(n.position)
		add_child(render_edge)
	for node in level_graph.nodes:
		add_child(node)

func _on_Generate_pressed():
	get_tree().call_group("Graph", "queue_free")
	level_graph.clear_graph()
	build_level()

func _on_Edge_status_changed():
	var color1 = Color(1,1,1)
	var color2 = Color(0.5,0.5,0.5)
	var render_edges = []
	
	if level_graph.path_built(): $ReadyLabel.set("custom_colors/font_color", color1)
	else: $ReadyLabel.set("custom_colors/font_color", color2)
	
	# Termination on Target -> no new selectable
	
	# The graph is just holding the abstract edges and not the real ones, which are rendered. 
	# Therefore the real edges must be collected first via the nodes in the graph, which
	# are the real ones and have references to the real edges.
	for n in level_graph.nodes:
		render_edges = SetMethods.union(render_edges, n.edges)
	for r_e in render_edges:
		r_e.change_selectable()

	for n in level_graph.nodes:
		if n.state == 1: # represents active state
			if n == level_graph.target:
				for e in n.edges:
					if e.state == Edge.Edge_States.SELECTABLE:
						e.change_state(Edge.Edge_States.UNSELECTED)

func _on_Hint_pressed():
	for e in solution_path:
		if e.hint_showing == false:
			e.hint_showing = true
			break
	_on_Edge_status_changed()