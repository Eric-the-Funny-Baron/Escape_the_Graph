extends Node2D

func _ready():
	var room_complete = get_node("..").level_log.size() > 0
	
	for l in get_tree().get_nodes_in_group("LevelLink"):
		if l.level_name in get_node("..").level_log: continue
		get_node("..")._on_level_save_requested(l.level_name, false, 1, false)
	
	for l in [$LevelLink, $LevelLink2, $LevelLink3]:
		room_complete = room_complete and get_node("..").level_log[l.level_name]["solved"]
	
	if room_complete:
		$Next_Room.set_as_opened()
	
	$Previous_Room.set_as_opened()