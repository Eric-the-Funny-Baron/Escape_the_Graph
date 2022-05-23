extends Node

class_name ColorTable

##
## @desc:
## Table to hold different colors to use them in different objects.
##

export var default_color : Color = Color(0.5, 0.5, 0.5)
export var selectable_color : Color = Color(0.85, 0.85, 0.85)
export var selected_color : Color = Color(0.63, 1, 0.42)
export var hint_color : Color = Color(0.79, 0, 0.52)
export var active_color : Color = Color(1, 0, 0)

export (Array, Color) var additional_colors
