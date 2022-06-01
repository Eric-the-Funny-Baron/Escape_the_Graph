extends Button


onready var hilfs_button = get_node("Node2D/Hilfsbutton")
onready var popup_window = get_node("ConfirmationDialog")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _on_HilfsButton_pressed():
	popup_window.popup()
