extends Node

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
	set_process_input(true)
	nSelectionPlane = get_node(MAP_PLANE_PATH)

func _fixed_process(delta):
	if(bLeftMouseButton && selDwarf == null):
		var world = get_node(CAMERA_PATH).get_world()
		var spaceState = world.get_direct_space_state()
		
		var dictionary = spaceState.intersect_ray(vFrom, vTo, [nSelectionPlane])
		
		if(!dictionary.empty()):
			var sel = dictionary["collider"]
			if(sel != null && sel.get_parent().has_method("select")):
				sel.get_parent().select()

				selDwarf = sel
		
		bLeftMouseButton = false
		
	if(bLeftMouseButton && selDwarf != null):
		var world = get_node(CAMERA_PATH).get_world()
		var spaceState = world.get_direct_space_state()
		
		var dictionary = spaceState.intersect_ray(vFrom, vTo, [nSelectionPlane, selDwarf])
		
		if(dictionary.empty()):
			var pathfinder = get_node(PATHFINDER_PATH)
			
			pathfinder.start(get_node(GRID_MAP_PATH))
			var vDest = pathfinder.get_closest_point_to_segment(vFrom, vTo)
			
			if(vDest != null && selDwarf.get_parent().has_method("walk")):
				selDwarf.get_parent().walk(vDest, pathfinder)
		
		bLeftMouseButton = false
	
	if(bMiddleMouseButton && selDwarf != null):
		var world = get_node(CAMERA_PATH).get_world()
		var spaceState = world.get_direct_space_state()
		
		var dictionary = spaceState.intersect_ray(vFrom, vTo, [selDwarf])
		
		if(!dictionary.empty()):
			var dest = dictionary["position"]
			
			if(dest != null && selDwarf.get_parent().has_method("dig")):
				selDwarf.get_parent().dig(dest)
		
		bMiddleMouseButton = false
	
func _input(event):
	if (event.type == InputEvent.MOUSE_BUTTON && event.is_pressed()):
		if(event.button_index == 1):
			var cam = get_viewport().get_camera()
			vFrom = cam.project_ray_origin(event.pos)
			vTo = vFrom + cam.project_ray_normal(event.pos)*100
			bLeftMouseButton = true
			bMiddleMouseButton = false
			
		if(event.button_index == 3 && selDwarf != null):
			var cam = get_viewport().get_camera()
			vFrom = cam.project_ray_origin(event.pos)
			vTo = vFrom + cam.project_ray_normal(event.pos)*100
			bMiddleMouseButton = true
			bLeftMouseButton = false
			
		if(event.button_index == 2):
			#right mouse button
			selDwarf = null
			bLeftMouseButton = false
			bMiddleMouseButton = false
