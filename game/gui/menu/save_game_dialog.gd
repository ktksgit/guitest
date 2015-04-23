extends FileDialog

var class_game_save = load("res://game/scripts/save/game_save.gd")

func _ready():
	# Initalization here
	set_mode(MODE_SAVE_FILE);
	set_title("Save a game")
	set_current_path("res://savegames/save.xscn")
	
	class_game_save 
	
	pass

func _on_SaveDialog_confirmed():
	if (class_game_save.reload() == OK):
		print ("reloading successful")
	
	var gameSaver = class_game_save.new()
	
	var world =  get_node("/root/Node/World")
	
	var camera = world.get_node("Camera")
	if(camera != null):
		camera.set_owner(world)
		var save = inst2dict(camera)
		#print (save)
		
	var map = world.get_node("GridMap")
	if (map != null):
		map.set_owner(world)
		
	#gameSaver.saveTree(world, map, "res://savegames/write_props.txt")
		
	var light = world.get_node("DirectionalLight")
	if (light != null):
		light.set_owner(world)
		
	var mapGen = world.get_node("SimpleMapGenerator")
	if (mapGen != null):
		mapGen.set_owner(world)
	
	var failed = false
	if (world != null):
		var pack = PackedScene.new()
		pack.pack(map)
		
		var res = ResourceSaver.save(get_current_path(), pack, ResourceSaver.FLAG_COMPRESS | ResourceSaver.FLAG_RELATIVE_PATHS )
		if (res != OK):
			failed = true
			
			if (res == ERR_FILE_UNRECOGNIZED):
				print ("wrong file type. Use .xscn")
			else:
				print ("Error-Code: ", res)
	else:
		failed = true
	
	if (failed):
		print ("Saving failed")
	
