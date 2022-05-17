extends Node2D

##
## This is the Level class of the game 'Escape the Graph'
##
## @desc:
##		The Level class will provide the functionality to generate Levels,
##		the possibility to interact with them and the system to evaluate the interaction.
##

# Parameters
export (PackedScene) var node_scene
export (PackedScene) var edge_scene
## @desc: 
## 		grid size for distribution of nodes -> 2 -> 4 grid fields for distribution
export var grid : int = 2
export var margin = 200.0 # border margin in the scene
export var node_number : int = 1 # number of nodes in the graph
export var edges : int = 1 # number of edges in the graph
enum ProblemType {SHORTEST_PATH, CAPACITY_PROBLEM, RELIABILITY_PROBLEM}
export (ProblemType) var type 
export var minimal_weight = 0.0 # minimal weight of edges
export var maximum_weight = 10.0 # maximum weight of edges

# Attributes
var screen_size
const SetMethods = preload("SetMethods.gd")


# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	randomize()
	distribute_objects(screen_size, grid, margin, node_number, edges)

func distribute_objects(total_size, density, margin, object_number, edge_number):
	
	# ==========================================================================
	# Node distribution
	# ==========================================================================
	var block_size = (total_size - Vector2(margin, margin)) / density
	var previous_node
	var filled_blocks = []
	var nodes = []
	
	for i in range(min(object_number, grid*grid)):
		var block = null
		var node = node_scene.instance()
		var random_offset = Vector2( \
			rand_range(-block_size.x, block_size.x), \
			rand_range(-block_size.y, block_size.y)) * 0.25
		
		while block == null or block in filled_blocks:
			block = Vector2(randi() % grid, randi() % grid)
		filled_blocks.append(block)
		node.position = block_size * 0.5 + block_size * block + random_offset
		add_child(node)
		nodes.append(node)
	
	# ==========================================================================
	# Edge Distribution
	# ==========================================================================
	var created_pairs = []
	
	for i in range(min(edge_number, object_number*(object_number-1)/2)):
		var pair = null
		var edge = edge_scene.instance()
		
		while pair == null or edge_exists_already(pair, created_pairs):
			var node1 = nodes[randi() % nodes.size()]
			var node2 = null
			
			while node2 == null or node2.position == node1.position:
				node2 = nodes[randi() % nodes.size()]
			
			pair = {
				'node1': node1.position, 
				'node2': node2.position
			}
		
		var inverted_pair = {
			'node1': pair['node2'],
			'node2': pair['node1']
			}
		created_pairs.append(pair)
		created_pairs.append(inverted_pair)
		
		edge.clear_points()
		edge.add_point(pair['node1'])
		edge.add_point(pair['node2'])
		add_child(edge)
	

func _on_Generate_pressed():
	get_tree().call_group("Graph", "queue_free")
	distribute_objects(screen_size, grid, margin, node_number, edges)

func edge_exists_already(edge, edges) -> bool:
	if edge == null or edges == []:
		return false 
	for i in range(edges.size()):
		if edge.hash() == edges[i].hash():
			return true
	return false

class Graph:
	var nodes = [] # contains all nodes
	var edges = [] # contains all edges
	var start = null
	var target = null
	
	func _init():
		pass
	
	func add_node(node):
		if (node in self.nodes) == false: nodes.append(node)
		return nodes
	
	func add_edge(node1, node2, weight):
		if node1 in self.nodes and node2 in self.nodes:
			var edge = {
				'targeting': {node1: node2, node2: node1},
				'weight': weight
			}
			self.edges.append(edge)
	
	func get_neighbours(node):
		var neighbours = []
		for edge in self.edges:
			for start in edge['targeting'].keys():
				if start == node:
					neighbours.append(edge['targeting'][node])
		return neighbours
	
	func get_edge_weight(node1, node2):
		for edge in self.edges:
			for start in edge['targeting'].keys():
				if start == node1 and edge['targeting'][start] == node2:
					return edge['weight']
	
	func define_start():
		if self.nodes !=  []:
			self.start = nodes[randi() % self.nodes.size()]
	
	func define_target(steps):
		var excluded_nodes = [self.start]
		for i in range(steps):
			for e in excluded_nodes:
				excluded_nodes = SetMethods.union(excluded_nodes, self.get_neighbours(e))
		
		var possible_nodes = SetMethods.difference(self.nodes, excluded_nodes)
		if possible_nodes == []:
			possible_nodes = SetMethods.difference(self.nodes, [self.start])
		if possible_nodes == []:
			return
		
		self.target = possible_nodes[randi() % possible_nodes.size()]
		return self.target
