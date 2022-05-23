extends Node

class_name SetMethods

static func intersect(array1 = [], array2 = []):
	var intersection = []
	for e in range(array1.size()):
		if array2.has(array1[e]):
			intersection.append(array1[e])
	return intersection

static func union(array1 = [], array2 = []):
	var union_arr = []
	
	for e in range(array1.size()):
		if (union_arr.has(array1[e])) == false: union_arr.append(array1[e])
	for e in range(array2.size()):
		if (union_arr.has(array2[e])) == false: union_arr.append(array2[e])
	return union_arr
	
static func difference(array1 = [], array2 = []):
	var diff = [] + array1
	
	for e in range(array1.size()):
		if array2.has(array1[e]): diff.erase(array1[e])
	return diff
	
