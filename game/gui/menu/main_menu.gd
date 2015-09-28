extends VBoxContainer

const SCENE_START = "res://game/world/demo/start.xscn"
const WORLD_PATH = "/root/Node/World"

func _ready():
	get_tree().set_pause(true)

func _on_Start_pressed():
	var ingame = get_node("../IngameGUI")
	var world = get_node(WORLD_PATH)
	
	if(ingame != null && world != null):
		print ("Starting")
		get_tree().set_pause(false)
		ingame.show()
		self.hide()
		
		if(!world.has_node("Map")):
			print ("Starting new Map")
			var scene = load(SCENE_START)
			var node = scene.instance()
			
			var children = node.get_children()
			for child in children:
				node.remove_child(child)
				world.add_child(child)
			node.free()
		
	else:
		print ("Start failed")


func _on_Load_pressed():
	get_node("LoadDialog").show()


func _on_Quit_pressed():
	get_tree().quit()


func _on_Save_pressed():
	get_node("SaveDialog").show()
