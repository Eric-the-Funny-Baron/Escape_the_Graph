extends ProgressBar

export (Gradient) var status_gradient:Gradient # idea I had for the color change - Eric

func _ready():
	get("custom_styles/fg").bg_color = status_gradient.interpolate(1.0)

func change_color(new_value):
	var tween = get_node("Tween_BarUpdates")
	var fraction = (get("value") - new_value)/100.0
	var green
	var red
	
	if (0.0<=fraction and fraction<0.5):        
		red = 1.0
		green = 2 * fraction
	if (0.5<=fraction and fraction <=1.0):       
		green = 1.0
		red = 1.0 - 2 * (fraction-0.5)
		
	get("custom_styles/fg").set_bg_color(Color(red, green, 0.00, 1.00))
	
	tween.interpolate_property(self, "value",
		get("value"), new_value, 0.5,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

func test_change_color(new_value): # 
	var tween:Tween = $Tween_BarUpdates
	tween.interpolate_property(self, "value", value, new_value, 0.5, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.interpolate_property(get("custom_styles/fg"), "bg_color", 
	Color(get("custom_styles/fg").bg_color), Color(status_gradient.interpolate(new_value * 0.01)), 
	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()


func _on_Tween_BarUpdates_tween_step(object, key, elapsed, value):
	self.update()
