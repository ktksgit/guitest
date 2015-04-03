extends FileDialog


func _ready():
	# Initalization here
	set_mode(MODE_OPEN_FILE);
	set_title("Load a game")
	
	pass

func _process(var delta):
	print (delta)
