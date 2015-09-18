extends FileDialog

var class_game_load = load("res://game/scripts/save/game_load.gd")

func _ready():
	# Initalization here
	set_mode(MODE_OPEN_FILE);
	set_title("Load a game")
	set_current_path("res://savegames/write_props.txt")


func _on_LoadDialog_confirmed():
	var base =  get_node("/root/Node")
	
	#delete old World node
	if(base.has_node("World")):
		base.remove_child(base.get_node("World"))
		# TODO: do we have to delete World in godot_1.1 or not???
	
	var game_loader = class_game_load.new(get_current_path(), class_game_load.LoadAsFile)
	
	game_loader.loadTree(base)
	
	#base.get_node("World/GridMap").show()
	
	self.hide()
	
	#pause the game
	get_tree().set_pause(true)
	return
	
	