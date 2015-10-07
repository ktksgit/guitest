extends Node

export(int) var abc = 0

func _init():
	print("initialized serialize.gd")
	
func onSave():
	return "serialize"
	
func onLoad(var dictionary):
	print("loaded: ", dictionary)