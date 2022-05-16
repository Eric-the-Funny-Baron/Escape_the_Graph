extends Node2D


export (PackedScene) var node_scene
export (PackedScene) var edge_scene
export var grid : int = 2
export var margin = 200.0
export var node_number : int = 1
export var edges : int = 1
var screen_size


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

# DEBUGGING NEEDED!!!
func edge_exists_already(edge, edges) -> bool:
	if edge == null or edges == []:
		return false 
	for i in range(edges.size()):
		if edge.hash() == edges[i].hash():
			return true
	return false
