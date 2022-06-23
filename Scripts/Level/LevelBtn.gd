extends Button

var locked = false

func set_disabled(state:bool):
	if locked: return
	disabled = state
