extends Dijkstra

class_name Shortest_Path

func _init(graph).(graph):
	._init(graph)
	self.ONE = 0
	self.ZERO = INFINITY # very high value, not infinity, for the low values it will work as infinity
		
		
func plus(operand1, operand2):
	return min(operand1, operand2)
	
func multiply(operand1, operand2):
	return operand1 + operand2
