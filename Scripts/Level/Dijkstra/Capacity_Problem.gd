extends Dijkstra

class_name Capacity_Problem

func _init(graph).(graph):
	._init(graph)
	self.ONE = self.INFINITY # very high value, not infinity, for the low values it will work as infinity
	self.ZERO = 0

func plus(operand1, operand2):
	return max(operand1, operand2)

func multiply(operand1, operand2):
	if operand1 == self.ONE:
		return operand2
	elif operand2 == self.ONE:
		return operand1
	return min(operand1, operand2)
