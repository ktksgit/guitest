extends Node

var bSaved = true
var bLoaded = true

func _ready():
	#var shape = load("res://game/char/dwarf/dwarf.xscn::1")
	
	var parent = get_parent()
	
	var node = get_node("/root/Node/World/Emerald")
	
	var adb = inst2dict(node)
	
	node = dict2inst(adb)
	
	var node = parent.get_node("Area")
	if(node != null):
		parent.remove_child(node)
		node.queue_free()
	
	set_process(true)
	print("TestBench ready")
	

func _process(delta):
	if(!bSaved):
		var dwarf = get_node("/root/Node/World/Emerald")
		dwarf.walk(Vector3(1,2,3), self)
		
		_test_save()
		bSaved = true
	
	if(!bLoaded):
		_test_load()
		bLoaded = true

func _test_load():
	var class_game_load = ResourceLoader.load("res://game/scripts/save/game_load.gd", "", true)
	
	var base =  get_node("/root/Node")
	
	#delete old World node
	if(base.has_node("World")):
		var world = base.get_node("World")
		base.remove_child(world)
		world.queue_free()
	
	var game_loader = class_game_load.new("res://savegames/test/save_dwarf", class_game_load.LoadAsFile)
	
	game_loader.loadTree(base)
	
	var dwarf = get_node("/root/Node/World/Emerald")
	var walkPath = dwarf.get("walkPath")
	
	print("walkPath", walkPath)

func _test_save():
	var class_game_save = load("res://game/scripts/save/game_save.gd")
	
	var gameSaver = class_game_save.new("res://savegames/test/save_dwarf", class_game_save.SaveAsFile)
	
	var world =  get_node("/root/Node/World")
	var parent = get_parent()
	if(world != null):
		gameSaver.saveTree(world)
	

func get_closest_point(point):
	return point
	
func get_simple_path(start, vDest):
	var array = Vector3Array()
	array.push_back(Vector3(1,2,3))
	array.push_back(Vector3(4,5,6))
	array.push_back(Vector3(1,2,3))
	array.push_back(Vector3(4,5,6))
	
	print("walkPath: ", array)
	return array


