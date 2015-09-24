extends Node

var from
var to
var mouse_clicked = false

const CAMERA_PATH = "/root/Node/World/Camera"

func _ready():
	set_fixed_process(true)
	set_process_input(true)
	
func _fixed_process(delta):
	if(mouse_clicked):
		var world = get_node(CAMERA_PATH).get_world()
		var spaceState = world.get_direct_space_state()
		var dictionary = spaceState.intersect_ray(from, to)
		
		if(!dictionary.empty()):
			var sel = dictionary["collider"]
			if(sel != null):
				sel.get_parent().select()
		
		mouse_clicked = false
	
func _input(event):
	if (event.type == InputEvent.MOUSE_BUTTON && event.is_pressed()):
		if(event.button_index == 1):
			var cam = get_viewport().get_camera()
			from = cam.project_ray_origin(event.pos)
			to = from + cam.project_ray_normal(event.pos)*100
			mouse_clicked = true