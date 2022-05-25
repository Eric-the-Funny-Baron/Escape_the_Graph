extends ProgressBar

func change_color(new_value):
	var tween = get_node("Tween_BarUpdates")
	var fraction = new_value/100.0
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
