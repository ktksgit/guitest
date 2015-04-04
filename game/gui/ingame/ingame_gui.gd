
extends EmptyControl

func _ready():
	# Initalization here
	pass


func _on_MainMenu_pressed():
	var menu = get_node("../MainMenu")
	var world = get_node("../../World")
	
	if(menu != null && world != null):
		menu.show()
		hide()
		world.set_pause_mode(PAUSE_MODE_STOP)
		#world.get_node("Spatial").set_process_input(false)
		#print(world.get_node("Spatial").get_pause_mode())
	else:
		print ("Entering main menu failed")
	
