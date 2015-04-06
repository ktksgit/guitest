
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
		#world.set_pause_mode(PAUSE_MODE_STOP)
		get_tree().set_pause(true)
	else:
		print ("Entering main menu failed")
	
