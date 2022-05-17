extends Polygon2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func define_as_start_target(size_factor : float, color : Color):
	self.color = color
	self.scale *= size_factor
