extends VBoxContainer

const SCENE_START = "res://game/world/demo/start.xscn"

func _ready():
	# Initalization here
	pass

func _on_Start_pressed():
	var ingame = get_node("../IngameGUI")
	var world = get_node("../../World")
	
	if(ingame != null && world != null):
		print ("Starting")
		ingame.show()
		hide()
		get_tree().set_pause(false)
		
		if(!world.has_node("GridMap")):
			print ("Starting new Map")
			var scene = load(SCENE_START)
			var node = scene.instance()
			
			get_node("/root/Node/World").add_child(node)
			node.set_pause_mode(PAUSE_MODE_INHERIT)
			node.show()
		
	else:
		print ("Start failed")
	


func _on_Load_pressed():
	get_node("LoadDialog").show()


func _on_Quit_pressed():
	get_tree().quit()


func _on_Save_pressed():
	get_node("SaveDialog").show()
