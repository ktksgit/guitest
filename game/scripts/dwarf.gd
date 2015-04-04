extends "res://scripts/serialize.gd"

var name = "alibaba"
var age = 5
var myref = 0

func set_name (value):
	myref = self
	name = value
	
func get_name ():
	return name