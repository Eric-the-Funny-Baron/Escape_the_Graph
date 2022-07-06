extends Node2D

var time = 0
var timeDirection = 1
var moveDuration = 0.5

func _ready():
	var room_complete = get_node("..").level_log.size() > 0
	$Arrow.hide()
	
	for l in get_tree().get_nodes_in_group("LevelLink"):
		if l.level_name in get_node("..").level_log: continue
		get_node("..")._on_level_save_requested(l.level_name, false, 1, false)
	
	for l in [$LevelLink, $LevelLink2, $LevelLink3]:
		room_complete = room_complete and get_node("..").level_log[l.level_name]["solved"]
	
	if room_complete:
		$Next_Room.set_as_opened()
		$Arrow.show()
		
	$Previous_Room.set_as_opened()
	
func _process(delta):

	if (time > moveDuration or time < 0):
		timeDirection *= -1

	time += delta * timeDirection
	var t = time / moveDuration

	$Arrow.position = lerp(Vector2(384.0,349.0),Vector2(395.0,349.0), t)
	

