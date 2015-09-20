extends Camera

export(Vector3) var pos

func _ready():
	set_process(true)
	set_process_input(true)
	
func _process(delta):
	pos = get_translation()
	var z = pos.z
	delta = z * delta
	if (Input.is_key_pressed(KEY_RIGHT)):
		pos = pos + Vector3(1,0,0) * delta;
		set_translation(pos)
	elif (Input.is_key_pressed(KEY_LEFT)):
		pos = pos + Vector3(-1,0,0) * delta;
		set_translation(pos);
	
	if (Input.is_key_pressed(KEY_UP)):
		pos = pos + Vector3(0, 1, 0) * delta;
		set_translation(pos)
	elif (Input.is_key_pressed(KEY_DOWN)):
		pos = pos + Vector3(0, -1, 0) * delta;
		set_translation(pos);


func _input(event):
	if (event.type == InputEvent.KEY && event.is_pressed()):
		if (event.scancode == KEY_KP_ADD):
			get_tree().set_input_as_handled()
			pos = get_translation() + Vector3(0,0,-1);
			set_translation(pos);
		if (event.scancode == KEY_KP_SUBSTRACT):
			get_tree().set_input_as_handled()
			pos = get_translation() + Vector3(0,0,1);
			set_translation(pos);