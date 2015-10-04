extends Panel

const WORLD_PATH = "/root/Node/World"
const INGAME_GUI_PATH = "/root/Node/GUI/IngameGUI"

var bGameStarted = false;

func _ready():
	get_tree().set_pause(true)

func _on_Start_pressed():
	get_tree().set_input_as_handled()
	var ingame = get_node(INGAME_GUI_PATH)
	
	if(ingame != null):
		if(bGameStarted):
			get_tree().set_pause(false)
			ingame.show()
			hide()
			return
	
	var scenarionDlg = get_node("ScenarioDialog")
	scenarionDlg.show_modal(true)
	return

func loadScenario(var name):
	var ingame = get_node(INGAME_GUI_PATH)
	var world = get_node(WORLD_PATH)
	
	if(ingame != null && world != null):
		print ("Starting")
		get_tree().set_pause(false)
		ingame.show()
		self.hide()
		
		if(!bGameStarted):
			print ("Starting new Map")
			var scene = load(name)
			var node = scene.instance()
			print ("Scene instance created. Reparenting children")
			var children = node.get_children()
			for child in children:
				node.remove_child(child)
				world.add_child(child)
			node.free()
			bGameStarted = true
		
	else:
		print ("Start failed")


func _on_Load_pressed():
	get_node("LoadDialog").show()


func _on_Quit_pressed():
	get_tree().quit()


func _on_Save_pressed():
	get_node("SaveDialog").show()
