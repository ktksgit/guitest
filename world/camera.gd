
extends Camera

func _ready():
	# Initalization here
	set_process(true)


func _process(delta):
	var speed = 4
	delta = speed * delta
	var pos = get_translation()
	if (Input.is_key_pressed(KEY_RIGHT)):
		pos = pos + Vector3(1,-1.3,1.5) * delta;
		set_translation(pos)
	elif (Input.is_key_pressed(KEY_LEFT)):
		pos = pos + Vector3(-1,1.3,-1.5) * delta;
		set_translation(pos)
	
	if (Input.is_key_pressed(KEY_UP)):
		pos = pos + Vector3(0,1,0.9) * delta;
		set_translation(pos)
	elif (Input.is_key_pressed(KEY_DOWN)):
		pos = pos + Vector3(0,-1,-0.9) * delta;
		set_translation(pos)


