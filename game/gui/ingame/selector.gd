extends Control

var vFrom
var vTo
var bLeftMouseButton = false
var bMiddleMouseButton = false

#selection area for digging commands
var nSelectionPlane

const CAMERA_PATH = "/root/Node/World/Camera"
const MAP_PLANE_PATH = "/root/Node/World/Area"
const GRID_MAP_PATH = "/root/Node/World/Map"
const PATHFINDER_PATH = "/root/Node/Globals/Pathfinder"

#current selections
var selDwarf = null

func _ready():
	set_fixed_process(true)
	#dont set process input here! set it after receiving signals "mouse_enter" or "mouse_exit"
	#set_process_input(true)
	nSelectionPlane = get_node(MAP_PLANE_PATH)

func _fixed_process(delta):
	if(bLeftMouseButton && selDwarf == null):
		bLeftMouseButton = false
		var world = get_node(CAMERA_PATH).get_world()
		var spaceState = world.get_direct_space_state()
		
		var dictionary = spaceState.intersect_ray(vFrom, vTo, [nSelectionPlane])
		
		if(!dictionary.empty()):
			var sel = dictionary["collider"]
			if(sel != null && sel.get_parent().has_method("select")):
				sel.get_parent().select()

				selDwarf = sel
		
	
	if(bLeftMouseButton && selDwarf != null):
		bLeftMouseButton = false
		var world = get_node(CAMERA_PATH).get_world()
		var spaceState = world.get_direct_space_state()
		
		var dictionary = spaceState.intersect_ray(vFrom, vTo, [nSelectionPlane, selDwarf])
		
		if(dictionary.empty() && has_node(GRID_MAP_PATH)):
			var pathfinder = get_node(PATHFINDER_PATH)
			
			pathfinder.start(get_node(GRID_MAP_PATH))
			var vDest = pathfinder.get_closest_point_to_segment(vFrom, vTo)
			
			if(vDest != null && selDwarf.get_parent().has_method("walk")):
				selDwarf.get_parent().walk(vDest, pathfinder)
		
		
	
	if(bMiddleMouseButton && selDwarf != null):
		bMiddleMouseButton = false
		var world = get_node(CAMERA_PATH).get_world()
		var spaceState = world.get_direct_space_state()
		
		var dictionary = spaceState.intersect_ray(vFrom, vTo, [selDwarf])
		
		if(!dictionary.empty()):
			var dest = dictionary["position"]
			
			if(dest != null && selDwarf.get_parent().has_method("dig")):
				selDwarf.get_parent().dig(dest)
		
		

func _input(event):
	#FIXME input is triggered even if GUI Element is clicked!
	if (event.type == InputEvent.MOUSE_BUTTON && event.is_pressed()):
		if(event.button_index == BUTTON_LEFT):
			var cam = get_viewport().get_camera()
			vFrom = cam.project_ray_origin(event.pos)
			vTo = vFrom + cam.project_ray_normal(event.pos)*100
			bLeftMouseButton = true
			bMiddleMouseButton = false
			
		if(event.button_index == BUTTON_MIDDLE && selDwarf != null):
			var cam = get_viewport().get_camera()
			vFrom = cam.project_ray_origin(event.pos)
			vTo = vFrom + cam.project_ray_normal(event.pos)*100
			bMiddleMouseButton = true
			bLeftMouseButton = false
			
		if(event.button_index == BUTTON_RIGHT):
			selDwarf = null
			bLeftMouseButton = false
			bMiddleMouseButton = false



func _on_Control_mouse_enter():
	set_process_input(true)


func _on_Control_mouse_exit():
	set_process_input(false)
