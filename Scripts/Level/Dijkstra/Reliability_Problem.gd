extends Dijkstra

class_name Reliability_Problem

func _init(graph).(graph):
		._init(graph)
		self.ONE = 1.0
		self.ZERO = 0.0

func plus(operand1, operand2):
	return max(operand1, operand2)

func multiply(operand1, operand2):
	return operand1 * operand2
