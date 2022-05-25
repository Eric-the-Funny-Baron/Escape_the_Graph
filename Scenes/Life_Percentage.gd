extends NinePatchRect

func change_text(new_value):
	var lab = get_node("Label")
	var counting = 1
	var current = lab.get_text()
	current.erase(current.length() - 2, 2)
	
	if(int(current)>new_value):
		counting = -1
	
	for n in range(int(current), int(new_value)+counting, counting):
		lab.set_text(str(n) + " %")
		yield(get_tree().create_timer(0.01), "timeout")



