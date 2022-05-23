extends Node

class_name Dijkstra

var graph = null
var table = {}
var ONE = "ONE" # algebraic "1" | 0 | infinity | 1
var ZERO = "ZERO" # algebraic "0" | infinity | 0 |
const INFINITY = 100000 # very high value, not infinity, for the low values it will work as infinity

func _init(graph):
	self.graph = graph

func plus(operand1, operand2):
	"""Algebraic +⨁ operation 
	   shortest path       -> min(a, b)
	   capacity problem    -> max(a, b)
	   reliability problem -> max(a, b)"""
	return

func multiply(operand1, operand2):
	"""Algebraic * operation"""
	return

func solve_path_problem():
	var current_node = null
	initialize_table()

	while true:
		current_node = get_best_node()
		table[current_node]['visited'] = true
		if current_node == graph.target:
			break
		var neighbours = graph.get_neighbours(current_node)
		update_table(current_node, neighbours)
	return {'path': build_path(), 'totalWeight': table[graph.target]['totalWeight']}

func build_path():
	var path = []
	var breakPoint = 0
	var current_node = graph.target
	while table[current_node]['predecessor'] != null:
		path.append(current_node)
		current_node = table[current_node]['predecessor']
		breakPoint += 1
	path.append(graph.start)
	path.invert()
	return path

func initialize_table():
	table.clear()
	for v in graph.nodes:
		table[v] = {'predecessor': null, 'totalWeight': ZERO, 'visited': false}
	table[graph.start] = {'predecessor': null, 'totalWeight': ONE, 'visited': false}

func get_best_node():
	var node = null
	for v in table.keys():
		if table[v]['visited'] == false:
			if node == null:
				node = v
			# if currentNode has a total distance = ZERO and the new node not -> then overwrite the current Node
			elif table[node]['totalWeight'] == ZERO and table[v]['totalWeight'] != ZERO:
				node = v
			elif table[v]['totalWeight'] == ZERO:
				pass
			# if both possible currentNodes have total distances not equal to ZERO then they can be compared
			elif table[node]['totalWeight'] != ZERO and table[v]['totalWeight'] != ZERO:
				if table[node]['totalWeight'] == plus(table[node]['totalWeight'], table[v]['totalWeight']): node = node
				else: node = v
	return node

func update_table(current_node, nodes):
	for v in nodes:
		var oldTotalWeight = table[v]['totalWeight']
		var newTotalWeight = multiply(table[current_node]['totalWeight'], graph.get_edge_weight(current_node, v))
		if table[v]['visited'] == true:
			continue
		if oldTotalWeight == ZERO:
			table[v]['predecessor'] = current_node
			table[v]['totalWeight'] = newTotalWeight
		elif newTotalWeight == plus(oldTotalWeight, newTotalWeight):
			table[v]['predecessor'] = current_node
			table[v]['totalWeight'] = newTotalWeight

func get_worst_weight():
	var weight = ONE
	for e in graph.edges:
		weight = multiply(weight, e['weight'])
	return weight
