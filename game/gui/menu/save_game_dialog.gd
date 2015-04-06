extends FileDialog

func _ready():
	# Initalization here
	set_mode(MODE_SAVE_FILE);
	set_title("Save a game")
	set_current_path("res://savegames/save.xscn")
	pass


func _on_SaveDialog_confirmed():
	
	var world =  get_node("/root/Node/World")
	
	var camera = world.get_node("Camera")
	if(camera != null):
		camera.set_owner(world)
		
	var map = world.get_node("GridMap")
	if (map != null):
		map.set_owner(world)
		
	var light = world.get_node("DirectionalLight")
	if (light != null):
		light.set_owner(world)
		
	var mapGen = world.get_node("SimpleMapGenerator")
	if (mapGen != null):
		mapGen.set_owner(world)
	
	var failed = false
	if (world != null):
		var pack = PackedScene.new()
		pack.pack(world)
		
		var res = ResourceSaver.save(get_current_path(), pack)
		if (res != OK):
			failed = true
			
		if (res == ERR_FILE_UNRECOGNIZED):
			print ("wrong file type. Use .xscn")
	else:
		failed = true
	
	if (failed):
		print ("Saving failed")
	
