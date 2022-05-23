extends Node

class_name Graph

# Graph is the abstract structure holding the elements representing a graph
# Additionally  it has some convinient getter methods helping with the game's logic.
# It also defines some elements required for a level in this game ->  so a start and a target.

var nodes = [] # contains all nodes
var edges = [] # contains all edges
var start = null # start of the graph's path start
var target = null # target in the level
	
func _init():
	pass

func clear_graph():
	self.nodes = []
	self.edges = []
	self.start = null
	self.target = null

func add_node(node):
	if (node in self.nodes) == false: nodes.append(node)
	return nodes

func create_edge(node1, node2, weight:float):
	var edge = {
		'targeting': {node1: node2, node2: node1},
		'weight': weight
		}
	return edge

func add_edge(edge):
	if edge_exists_already(edge):
		return edge
	self.edges.append(edge)
	return edge

func edge_exists_already(edge) -> bool:
	if edge == null or self.edges == []:
		return false 
	for i in range(edges.size()):
		var keys = edge['targeting'].keys()
		var normal = keys == edges[i]['targeting'].keys()
		keys.invert()
		var inverted = keys == edges[i]['targeting'].keys()
		if normal or inverted:
			return true
	return false

func get_neighbours(node):
	var neighbours = []
	for edge in self.edges:
		for s in edge['targeting'].keys():
			if s == node:
				neighbours.append(edge['targeting'][node])
	return neighbours

func get_edge(node1, node2):
	for edge in self.edges:
		for s in edge['targeting'].keys():
			if s == node1 and edge['targeting'][s] == node2:
				return edge

func get_edge_weight(node1, node2):
	return self.get_edge(node1, node2)['weight']

func define_start():
	if self.nodes !=  []:
		self.start = nodes[randi() % self.nodes.size()]

func define_target(steps:int):
	var excluded_nodes = [self.start]
	for _i in range(steps):
		var new_excluded_nodes = []
		for e in excluded_nodes:
			new_excluded_nodes = SetMethods.union(excluded_nodes, self.get_neighbours(e))
		excluded_nodes = new_excluded_nodes
	
	var possible_nodes = SetMethods.difference(self.nodes, excluded_nodes)
	if possible_nodes == []:
		possible_nodes = SetMethods.difference(self.nodes, [self.start])
	if possible_nodes == []:
		var exception = SetMethods.difference(excluded_nodes, [start])
		self.target = exception[randi() % exception.size()]
		return self.target
	
	self.target = possible_nodes[randi() % possible_nodes.size()]
	return self.target

func path_built(node : Level_Node = start, visited = []) -> bool:
	var built:bool = false
	var nodes_to_be_checked = []
	visited.append(node)
	
	if node == target:
		return true
	
	for e in node.get_active_edges():
		nodes_to_be_checked = SetMethods.union(nodes_to_be_checked, e.nodes)
	nodes_to_be_checked = SetMethods.difference(nodes_to_be_checked, visited)
	
	for n in nodes_to_be_checked:
		built = built or path_built(n, visited)
		if built:
			return true
	
	return false
