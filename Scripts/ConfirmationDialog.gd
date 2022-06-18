extends Popup

export(ButtonGroup) var group1
export(ButtonGroup) var group2
export(ButtonGroup) var group3
export(ButtonGroup) var group4
var first = ""
var second = ""
var third = ""
var fourth = ""

func _ready():
	Signals.connect("confirmation_requested", self, "_on_confirmation_requested")
	for i in group1.get_buttons():
		i.connect("pressed", self, "_on_pressed1")
	for i in group2.get_buttons():
		i.connect("pressed", self, "_on_pressed2")
	for i in group3.get_buttons():
		i.connect("pressed", self, "_on_pressed3")
	for i in group4.get_buttons():
		i.connect("pressed", self, "_on_pressed4")

func _on_pressed1():
	first = group1.get_pressed_button().name
	_check_all()

func _on_pressed2():
	second = group2.get_pressed_button().name
	_check_all()

func _on_pressed3():
	third = group3.get_pressed_button().name
	_check_all()

func _on_pressed4():
	fourth = group4.get_pressed_button().name
	_check_all()
	
func _check_all():
	if (first == second && second == third && third == fourth && fourth == "Yes"):
		self.hide()
		Signals.emit_signal("yes_pressed")
	elif (first == "" || second == "" || third == "" || fourth == ""):
		pass
	else:
		self.hide()
		Signals.emit_signal("no_pressed")

func _on_confirmation_requested():
	self.show()
	Signals.emit_signal("help_update_requested", "Level_Confirmation")


func _on_ConfirmationDialog_hide():
	Signals.emit_signal("help_update_requested", "Level")
	if (first != ""):
		group1.get_pressed_button().pressed = false
	if (second != ""):
		group2.get_pressed_button().pressed = false
	if (third != ""):
		group3.get_pressed_button().pressed = false
	if (fourth != ""):
		group4.get_pressed_button().pressed = false
	first = ""
	second = ""
	third = ""
	fourth = ""
