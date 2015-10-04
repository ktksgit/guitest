extends Camera

func _ready():
	set_process(true)
	set_process_input(true)
	
func _process(delta):
	var pos = get_translation()
	var z = pos.z
	delta = log(z+1)  * delta
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

func move(var direction):
	var pos = get_translation()
	var z = pos.z
	direction = log(z+1) * direction
	set_translation(pos + direction)

func _input(event):
	var pos = get_translation()
	if(event.type == InputEvent.MOUSE_BUTTON):
		if(event.button_index == BUTTON_WHEEL_DOWN):
			set_translation(pos  + Vector3(0,0,1))
		if(event.button_index == BUTTON_WHEEL_UP):
			set_translation(pos  + Vector3(0,0,-1))
	
	if (event.type == InputEvent.KEY && event.is_pressed()):
		if (event.scancode == KEY_KP_ADD):
			get_tree().set_input_as_handled()
			set_translation(pos  + Vector3(0,0,-1))
		if (event.scancode == KEY_KP_SUBSTRACT):
			get_tree().set_input_as_handled()
			set_translation(pos  + Vector3(0,0,1))
	
	pos = get_translation()
	if(pos.z < 0):
		set_translation(pos + Vector3(0, 0, -pos.z + 1))
		