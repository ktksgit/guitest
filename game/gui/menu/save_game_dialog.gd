extends FileDialog

var class_game_save = load("res://game/scripts/save/game_save.gd")

func _ready():
	# Initalization here
	set_mode(MODE_SAVE_FILE);
	set_title("Save a game")
	set_current_path("res://savegames/write_props.txt")
	
	pass

func _on_SaveDialog_confirmed():
	if (class_game_save.reload() == OK):
		print ("reloading successful")
	
	var gameSaver = class_game_save.new(get_current_path(), class_game_save.SaveAsFile)
	
	var world =  get_node("/root/Node/World")
	gameSaver.saveTree(world)
	
	#var gameSaver = class_game_save.new(get_current_path() + ".xscn", class_game_save.SaveAsScene)
	#gameSaver.saveTree(world)
	
	return;