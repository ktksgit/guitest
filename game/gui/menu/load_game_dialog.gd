extends FileDialog

var class_game_load = load("res://game/scripts/save/game_load.gd")

func _ready():
	# Initalization here
	set_mode(MODE_OPEN_FILE);
	set_title("Load a game")
	set_current_path("res://savegames/save.xscn")


func _on_LoadDialog_confirmed():
	var base =  get_node("/root/Node")
	
	#delete old World node
	if(base.has_node("World")):
		base.remove_child(base.get_node("World"))
		# TODO: do we have to delete World in rc3 or not???
	
	var game_loader = class_game_load.new("res://savegames/write_props.txt", class_game_load.LoadAsFile)
	
	game_loader.loadTree(base)
	
	#pause the game
	get_tree().set_pause(true)
	return
	
	#dead code
	
	var world = load(get_current_path())
	if (world != null):
		#delete old hierarchy
		if(base.has_node("World")):
			base.remove_and_delete_child(base.get_node("World"))
		
		var n = world.instance()
		base.add_child(n)
		get_tree().set_pause(true)
	else:
		print ("loading failed. Error: ", world)